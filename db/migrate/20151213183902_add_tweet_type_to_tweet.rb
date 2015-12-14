class AddTweetTypeToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :tweet_type, :string
  end
end
