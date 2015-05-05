class AddUserIdToConn < ActiveRecord::Migration
  def change
  	add_column :connections, :user_id, :integer
  end
end
