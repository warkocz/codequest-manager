class User < ActiveRecord::Base
  ACCEPTABLE_EMAILS = %w(codequest.com codequest.eu)

  has_many :orders
  has_many :user_balances, dependent: :destroy
  has_many :balances_as_payer, class_name: 'UserBalance', inverse_of: :payer, foreign_key: :payer_id
  has_many :submitted_transfers, inverse_of: :from, class_name: 'Transfer', foreign_key: :from_id
  has_many :received_transfers, inverse_of: :to, class_name: 'Transfer', foreign_key: :to_id

  after_create :add_first_balance

  scope :by_name, -> { order 'name' }

  devise :database_authenticatable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:google_oauth2]

  def self.from_omniauth(data)
    user = find_by(data.slice(:provider, :uid).to_h)
    if user.nil? && data.info.email.split('@')[1].in?(ACCEPTABLE_EMAILS)
      user = User.new({
                          provider: data.provider,
                          uid: data.uid,
                          name: data.info.name,
                          email: data.info.email
                      })
      user.save!
    end
    user
  end

  def balances
    @balances ||= UserBalance.balances_for(self)
  end

  def debts
    @debts ||= UserBalance.debts_to(self)
  end

  def add_first_balance
    user_balances.create balance: 0, payer: self
  end

  def subtract(amount, payer)
    return if self == payer && !substract_from_self
    user_balances.create balance: payer_balance(payer) - amount, payer: payer
  end

  def to_s
    name
  end

  def payer_balance(payer)
    user_balances.newest_for(payer.id).try(:balance) || Money.new(0, 'PLN')
  end

  def total_balance
    balances.map(&:balance).reduce :+
  end

  def total_debt
    debts.inject(Money.new(0,'PLN')) {|sum, debt| sum = sum+debt.balance}
  end
end