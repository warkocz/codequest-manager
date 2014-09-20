require 'spec_helper'

describe UserBalanceDecorator do
  before do
    @user = create(:user)
    @user_balance = build(:user_balance) do |user_balance|
      user_balance.user = @user
      user_balance.payer = @user
      user_balance.balance_cents = 1241
    end
    @user_balance.save!
    @decorator = @user_balance.decorate
  end

  it 'should to_s' do
    expect(@decorator.to_s).to eq(@user_balance.balance.to_s)
  end

end