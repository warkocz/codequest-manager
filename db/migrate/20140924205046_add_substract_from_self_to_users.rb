class AddSubstractFromSelfToUsers < ActiveRecord::Migration
  def change
    add_column :users, :substract_from_self, :boolean, default: false
  end
end
