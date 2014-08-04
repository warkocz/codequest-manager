class RemoveColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :reset_password_sent_at, :string
    remove_column :users, :reset_password_token, :string
  end
end
