class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.references :tweet, index: true
      t.string :source_type
      t.string :source

      t.timestamps null: false
    end
  end
end
