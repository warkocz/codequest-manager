class Dish < ActiveRecord::Base
  belongs_to :user
  belongs_to :order

  validates :price, numericality: true, presence: true
  validates :name, presence: true

  before_create :ensure_uniqueness

  def ensure_uniqueness
    return if Dish.find_by order: order, user: user
    true
  end
end
