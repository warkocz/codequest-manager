class Order < ActiveRecord::Base
  belongs_to :user
  has_many :dishes, dependent: :destroy

  before_create :ensure_one_order_per_day

  validates :user, presence: true

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
end
