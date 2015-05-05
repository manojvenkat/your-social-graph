class Connection < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user, :foreign_key => "connection_owner_id"
  validates_uniqueness_of :screen_name, :scope => :user_id


  has_many :tweets
  module ConnectionType
  	FOLLOWER = 0
  	FRIEND = 1
  end
end
