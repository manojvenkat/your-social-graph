class AddAnalysisFlagToTweet < ActiveRecord::Migration
  def change
  	add_column :tweets, :analyzed, :boolean, :default => false
  end
end
