class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
			t.string :name
			t.string :id_str
			t.string :screen_name
			t.integer :connection_owner_id
			t.string :keywords
			t.string :location
			t.integer :type
      t.timestamps
    end
  end
end
