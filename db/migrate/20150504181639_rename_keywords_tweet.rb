class RenameKeywordsTweet < ActiveRecord::Migration
  def up
  	rename_column :users, :key_words, :keywords
  end

  def down
  end
end
