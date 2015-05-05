class Connection < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user, :foreign_key => "connection_owner_id"
  validates_uniqueness_of :screen_name, :scope => [:user_id, :conn_type]

  has_many :tweets
  module ConnectionType
  	FOLLOWER = 0
  	FRIEND = 1
  end

  def self.get_lat_long_for_connection(location)
  	geokit_obj = Geokit::Geocoders::GoogleGeocoder.geocode location
  	lat_long = geokit_obj.ll.split(',')
  	lat_long
  end
end
