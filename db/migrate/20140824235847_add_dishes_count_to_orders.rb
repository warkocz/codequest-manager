class AddDishesCountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :dishes_count, :integer, default: 0
  end
end
