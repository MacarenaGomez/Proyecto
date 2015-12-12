class RemoveLinkedinFromExpert < ActiveRecord::Migration
  def change
    remove_column :experts, :linkedin, :string
  end
end
