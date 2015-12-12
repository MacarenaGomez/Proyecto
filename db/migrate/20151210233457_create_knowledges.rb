class CreateKnowledges < ActiveRecord::Migration
  def change
    create_table :knowledges do |t|
      t.references :expert, index: true
      t.references :topic, index: true
      t.timestamps null: false
    end
  end
end
