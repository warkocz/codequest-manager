class Order < ActiveRecord::Base
  belongs_to :orderer, class_name: 'User'

  before_create :ensure_one_order_per_day

  def ensure_one_order_per_day
    return if Order.find_by date: Date.today
    true
  end
end
