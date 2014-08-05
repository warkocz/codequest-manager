class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.date :date
      t.references :orderer, index: true

      t.timestamps
    end
  end
end
