class CreateExperts < ActiveRecord::Migration
  def change
    create_table :experts do |t|
      t.string :name
      t.string :twitter
      t.string :linkedin
      t.timestamps null: false
    end
  end
end
