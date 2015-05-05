class AddUsefulColumnsToUserAndTweetModels < ActiveRecord::Migration
  def change
  	add_column :tweets, :user_id, :integer
  	add_column :tweets, :connection_id, :integer
  	add_column :users, :key_words, :string
  end
end
