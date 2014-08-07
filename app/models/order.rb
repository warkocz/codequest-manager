class Order < ActiveRecord::Base
  belongs_to :orderer, class_name: 'User'
  has_many :dishes

  before_create :ensure_one_order_per_day

  validates :orderer, presence: true

  def self.todays_order
    find_by date: Date.today
  end

  def ensure_one_order_per_day
    return if Order.find_by date: Date.today
    true
  end

  def amount
    dishes.count
  end
end
