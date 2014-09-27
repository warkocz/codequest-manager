class RenamePriceToPriceCentsOnDish < ActiveRecord::Migration
  def change
    rename_column :dishes, :price, :price_cents
  end
end
