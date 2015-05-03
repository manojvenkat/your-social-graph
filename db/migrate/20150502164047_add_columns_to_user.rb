class AddColumnsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :provider, :string
  	add_column :users, :uid, :string
  	add_column :users, :name, :string	
 	remove_column :users, :email
 	remove_column :users, :fb_user_id
  end
end
