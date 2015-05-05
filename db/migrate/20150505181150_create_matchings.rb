class CreateMatchings < ActiveRecord::Migration
  def change
    create_table :matchings do |t|
      t.integer :conn_1_id
      t.integer :conn_2_id
      t.float   :match_percent
      t.integer :user_id
      t.timestamps
    end
  end
end
