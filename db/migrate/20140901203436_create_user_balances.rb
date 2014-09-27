class CreateUserBalances < ActiveRecord::Migration
  def change
    create_table :user_balances do |t|
      t.integer :balance_cents
      t.references :user, index: true

      t.timestamps
    end
  end
end
