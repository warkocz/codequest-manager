class RenameOrdererIdToUserIdOnOrder < ActiveRecord::Migration
  def change
    rename_column :orders, :orderer_id, :user_id
  end
end
