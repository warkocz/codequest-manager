class Order < ActiveRecord::Base
  belongs_to :user
  has_many :dishes, dependent: :destroy

  before_create :ensure_one_order_per_day

  validates :user, presence: true
  validates :from, presence: true

  scope :past, -> { where.not(date: Date.today).order('date desc')}
  register_currency :pln
  monetize :shipping_cents

  enum status: [:in_progress, :ordered, :delivered]

  def self.todays_order
    find_by date: Date.today
  end

  def ensure_one_order_per_day
    return if Order.find_by date: Date.today
    true
  end

  def amount
    initial = Money.new(0, 'PLN')
    dishes.inject(initial) {|sum, dish| sum + dish.price }
  end

  def change_status!
    int_status = Order.statuses[status]
    if int_status < Order.statuses.count - 1
      self.status = int_status+1
      subtract_price if int_status == 1
      save!
    end
  end

  def subtract_price
    return if dishes_count == 0
    dishes.each do |dish|
      dish.subtract shipping/(dishes_count), user
    end
  end
end
