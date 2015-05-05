class RenameTypeToConnType < ActiveRecord::Migration
  def up
  	rename_column :connections, :type, :conn_type
  end

  def down
  end
end
