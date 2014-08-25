class Dish < ActiveRecord::Base
  belongs_to :user
  belongs_to :order, counter_cache: true

  validates :price, numericality: true, presence: true
  validates :name, presence: true

  before_create :ensure_uniqueness

  scope :by_date, -> {order('created_at')}

  def ensure_uniqueness
    return if Dish.find_by order: order, user: user
    true
  end
end
