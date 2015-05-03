class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fb_user_id
      t.string :email

      t.timestamps
    end
  end
end
