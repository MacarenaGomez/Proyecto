class RemoveTweeterFromExpert < ActiveRecord::Migration
  def change
    remove_column :experts, :twitter, :string
  end
end
