class AddRateToExpert < ActiveRecord::Migration
  def change
    add_column :experts, :rate, :integer
  end
end
