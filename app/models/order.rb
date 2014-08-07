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
    dishes.inject(0) {|sum, dish| sum + dish.price }
  end

  def dish_for_user(user)
    dishes.find_by(user: user)
  end

  def other_dishes(excluded)
    dishes.where.not(user: excluded)
  end
end
