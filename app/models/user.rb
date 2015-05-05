class User < ActiveRecord::Base
  attr_accessible :uid, :oauth_token, :oauth_expires_at

  validates_presence_of :uid, :oauth_token, :oauth_secret

  after_create :get_user_content

  has_many :connections
  has_many :tweets

  def self.from_omniauth(auth)
    user = where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
    user.oauth_token = auth["credentials"]["token"]
    user.oauth_secret = auth["credentials"]["secret"]
    user.name = auth["info"]["name"]
    user.twitter_handle = auth["info"]["nickname"]
    user.image_url = auth["info"]["image"]
    user.save!
    user
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.twitter_handle = auth["info"]["nickname"]
      user.oauth_token = auth["credentials"]["token"]
      user.oauth_secret = auth["credentials"]["secret"]
      user.image_url = auth["info"]["image"]
    end
    # user.delay.get_user_content
    # user.delay.save_recent_tweets_self
  end


  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil
  end

  def friends_count
    facebook { |fb| fb.get_connections("me", "friends").size }
  end

  def twitter
    if provider == "twitter"
      @twitter ||= Twitter::Client.new(oauth_token: oauth_token, oauth_token_secret: oauth_secret)
    end
  end

  def rest_client
    rest_client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token = ENV["TWITTER_OAUTH_TOKEN"]
      config.access_token_secret = ENV["TWITTER_OAUTH_TOKEN_SECRET"]
    end
  end

  def save_followers_list
    followers_index = 0
    begin
      followers_cursor_obj = self.rest_client.followers(self.twitter_handle) if followers_cursor_obj.nil?
      followers = followers_cursor_obj.to_a
    rescue Twitter::Error::RateLimited, Twitter::Error::TooManyRequests => error
      if followers.present? && (followers.count > followers_index)
        save_follower_or_friend_objects(followers, followers_index)
      end
      puts "Sleeping for " + error.rate_limit.reset_in.to_s
      sleep error.rate_limit.reset_in
      retry
    end
    save_follower_or_friend_objects(followers, followers_index)
  end

  def save_friends_list
    friends_index = 0
    begin
      friends_cursor_obj = self.rest_client.friends(self.twitter_handle) if friends_cursor_obj.nil?
      friends = friends_cursor_obj.to_a
    rescue Twitter::Error::RateLimited, Twitter::Error::TooManyRequests => error
      if friends.present? && (friends.count > friends_index)
        save_follower_or_friend_objects(friends, friends_index)
      end
      puts "Sleeping for " + error.rate_limit.reset_in.to_s
      sleep error.rate_limit.reset_in
      retry
    end
    save_follower_or_friend_objects(friends, friends_index)
  end

  def save_tweets(owner_object, twitter_handle, num_tweets)
    tweets_index = 0
    begin
      tweet_set_cursor = self.rest_client.user_timeline(twitter_handle, {:count => num_tweets}) if tweet_set_cursor.nil?
      tweet_set = tweet_set_cursor.to_a
    rescue Twitter::Error::RateLimited, Twitter::Error::TooManyRequests => error
      if tweet_set.present? && (tweet_set.count > tweets_index)
        push_tweets_into_db(owner_object, tweet_set, tweets_index)
      end
    end
    push_tweets_into_db(owner_object, tweet_set, tweets_index)
  end

  def save_recent_tweets_self
    self.save_tweets(self, self.twitter_handle, 40)
  end

  def save_recent_tweets_conns
    self.connections.each do |conn|
      self.save_tweets(conn, conn.screen_name, 20)
    end
  end

  def save_follower_or_friend_objects(follower_or_friend_objs, index)
    loop do
      begin
        follower_or_friend = follower_or_friend_objs[index]
        conn = self.connections.new
        conn.name = follower_or_friend.name
        conn.screen_name = follower_or_friend.name
        conn.location = follower_or_friend.location
        lat_long = Connection.get_lat_long_for_connection(conn.location)
        conn.latitude = lat_long[0]
        conn.longitude = lat_long[1]
        conn.conn_type = Connection::ConnectionType::FOLLOWER
        conn.save!
      rescue ActiveRecord::RecordInvalid
        puts "Skipping.."
      end
      index += 1
      break if index >= follower_or_friend_objs.count
    end
  end

  def push_tweets_into_db(owner_object, tweet_objs, index)
    loop do
      tweet_obj = tweet_objs[index]
      tweet = owner_object.tweets.new
      tweet.tweet_content = tweet_obj.text
      tweet.save!
      index += 1
      break if index >= tweet_objs.count
    end
  end

  def get_user_content
    self.delay.get_connections_content
    self.delay.save_recent_tweets_self
  end

  def get_connections_content
    self.save_followers_list
    self.save_friends_list
    self.save_recent_tweets_conns
  end

  def self.calculate_matches_between_conns
    User.all.each do |user|
      conns = user.connections
        for match_counter in 0..(conns.count-1)        
          for target_counter in 0..(counter-1)
            match_value = User.calculate_match(conns[target_counter].keywords, conns[match_counter].keywords)
            Matching.create!(conn_1_id: target_counter, conn_2_id: match_counter, match_percent: match_value)
          end
        end
      end
    end
  end

  def self.calculate_match(conn_1_keywords, conn_2_keywords)
    keywords_1 = conn_1_keywords.downcase.split(',').uniq
    keywords_2 = conn_2_keywords.downcase.split(',').uniq
    union_keywords_size = (keywords_1 | keywords_2).size.to_f 
    if union_keywords_size > 0 
      return (keywords_1 & keywords_2).size.to_f/union_keywords_size
    else
      return 0
    end
  end

  def self.calculate_match_with_conns
    User.all.each do |user|
      conns = user.connections
      conns.each do |conn|
        match_value = User.calculate_match(user.keywords, conn.keywords)
        Matching.create!(conn_1_id: conn.id, user_id: user.id, match_percent: match_value)
      end
    end
  end
end
