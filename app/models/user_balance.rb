class UserBalance < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true

  register_currency :pln
  monetize :balance_cents

  scope :newest, -> { order('created_at desc') }

end