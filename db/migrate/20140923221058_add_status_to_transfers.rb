class AddStatusToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :status, :integer, default: 0
  end
end
