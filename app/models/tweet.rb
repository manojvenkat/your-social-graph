class Tweet < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :connection
  belongs_to :user

  scope :not_analyzed, -> { where(analyzed: false) }

  def self.get_keywords
  	Tweet.not_analyzed.each do |tweet|
  		tweet_text = tweet.tweet_content.gsub(/(?:f|ht)tps?:\/[^\s]+/, '')
  		result = Highscore::Content.new tweet_text
  		keywords = result.keywords.top(result.keywords.count)
  		keywords_string = ''
  		keywords.each do |word|
  			keywords_string +=	word.to_s.stem + ','
  		end
  		if tweet.connection.present?
  			present_keywords = tweet.connection.keywords.to_s
  			present_keywords += keywords_string
  			tweet.connection.keywords = present_keywords
  			tweet.connection.save!
  		elsif tweet.user.present?
  			present_keywords = tweet.user.keywords.to_s
  			present_keywords += keywords_string
  			tweet.user.keywords = present_keywords
  			tweet.user.save!
  		end
  		tweet.analyzed = true
  		tweet.save!
  	end
  end
end

