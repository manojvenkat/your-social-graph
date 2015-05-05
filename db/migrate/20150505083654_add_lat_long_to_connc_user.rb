class AddLatLongToConncUser < ActiveRecord::Migration
  def change
  	add_column :connections, :longitude, :string
  	add_column :connections, :latitude, :string
  end
end
