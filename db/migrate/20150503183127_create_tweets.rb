class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
    	t.string :ref_obj_type
    	t.integer :ref_obj_id
    	t.string :tweet_content 
      t.timestamps
    end
  end
end
