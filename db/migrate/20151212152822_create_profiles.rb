class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :expert, index: true
      t.string :url
      t.string :profile_image_url
      t.string :location
      t.text   :description
      t.string :profile_type
      t.string :screen_name
      t.timestamps null: false
    end
  end
end
