class UserObserver < ActiveRecord::Observer
	def after_create(user)
		debugger
		# user.delay.get_user_content
		# user.delay.save_recent_tweets_self
	end
end