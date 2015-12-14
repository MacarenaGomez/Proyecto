class RemoveLinkFromTweet < ActiveRecord::Migration
  def change
    remove_column :tweets, :link, :string
  end
end
