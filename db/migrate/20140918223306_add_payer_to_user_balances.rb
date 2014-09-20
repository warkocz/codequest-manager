class AddPayerToUserBalances < ActiveRecord::Migration
  def change
    add_reference :user_balances, :payer, index: true
  end
end
