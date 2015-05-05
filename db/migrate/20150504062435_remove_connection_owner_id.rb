class RemoveConnectionOwnerId < ActiveRecord::Migration
  def up
  	remove_column :connections, :connection_owner_id
  end

  def down
  end
end
