class Matching < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :conn_1_id, :conn_2_id, :match_percent
end
