class CreateTwitterApis < ActiveRecord::Migration
  def change
    create_table :twitter_apis do |t|

      t.timestamps null: false
    end
  end
end
