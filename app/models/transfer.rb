class Transfer < ActiveRecord::Base
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'

  validates :from, :to, presence: true

  scope :newest_first, -> { order 'updated_at desc' }

  register_currency :pln
  monetize :amount_cents

  enum status: [:pending, :accepted, :rejected]

  def mark_as_accepted!
    accepted!
    from.user_balances.create balance: (from.payer_balance(to) + amount), payer: to
  end
end