class RenameCostToPriceOnDishes < ActiveRecord::Migration
  def change
    rename_column :dishes, :cost, :price
  end
end
