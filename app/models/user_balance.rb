class UserBalance < ActiveRecord::Base
  belongs_to :user

  register_currency :pln
  monetize :balance_cents

  scope :newest, -> { order('created_at desc') }

end