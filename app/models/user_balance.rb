class UserBalance < ActiveRecord::Base
  belongs_to :user
  belongs_to :payer, class_name: 'User'

  validates :user, presence: true
  validates :payer, presence: true

  register_currency :pln
  monetize :balance_cents

  scope :newest_for, -> (payer_id) {where(payer_id: payer_id).order('created_at desc').first}

  def self.balances_for(user)
    payers_ids(user).map do |payer_id|
      user.user_balances.newest_for(payer_id)
    end
  end

  def self.payers_ids(user)
    user.user_balances.select('payer_id').uniq.map(&:payer_id)
  end

  def self.debts_to(user)
    debtors_ids(user).map do |debtor_id|
      debtor = User.find(debtor_id)
      debtor.user_balances.newest_for(user)
    end
  end

  def self.debtors_ids(user)
    user.balances_as_payer.select('user_id').uniq.map(&:user_id)
  end
end