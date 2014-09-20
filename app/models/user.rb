class User < ActiveRecord::Base
  ACCEPTABLE_EMAILS = %w(codequest.com codequest.eu)

  has_many :orders
  has_many :user_balances, dependent: :destroy

  after_create :add_first_balance

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
    UserBalance.balances_for(self)
  end

  def add_first_balance
    user_balances.create balance: 0, payer: self
  end

  def subtract(amount, payer)
    user_balances.create balance: payer_balance(payer) - amount, payer: payer
  end

  def to_s
    name
  end

  def payer_balance(payer)
    user_balances.newest_for(payer.id).balance
  end

  def total_balance
    balances.map(&:balance).reduce :+
  end
end
