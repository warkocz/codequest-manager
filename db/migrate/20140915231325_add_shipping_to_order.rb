class AddShippingToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_cents, :integer, default: 0
  end
end
