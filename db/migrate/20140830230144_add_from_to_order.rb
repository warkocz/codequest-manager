class AddFromToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :from, :string
  end
end
