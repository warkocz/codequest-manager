class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.references :from, index: true
      t.references :to, index: true
      t.integer :amount_cents

      t.timestamps
    end
  end
end
