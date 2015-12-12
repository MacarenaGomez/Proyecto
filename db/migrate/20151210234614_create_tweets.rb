class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.references :expert, index: true
      t.string     :text
      t.integer    :rate
      t.date       :date
      t.string     :link
      t.timestamps null: false
    end
  end
end
