class Tweet < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :connection
  belongs_to :user

  scope :not_analyzed, -> { where(analyzed: false) }

  def self.get_keywords
  	Tweet.not_analyzed.each do |tweet|
  		tweet_text = tweet.tweet_content.gsub(/(?:f|ht)tps?:\/[^\s]+/, '')
  		result = Highscore::Content.new tweet_text
  		keywords = result.keywords(result.keywords.count)
  		keywords_string = ''
  		keywords.each do |word|
  			keywords_string +=	word.stem + ','
  		end
  		if tweet.connection.present?
  			tweet.connection.keywords += keywords_string
  			tweet.connection.save!
  		elsif tweet.user.present?
  			tweet.user.keywords += keywords_string
  			tweet.user.save!
  		end
  		tweet.analyzed = true
  		tweet.save!
  	end
  end
end

