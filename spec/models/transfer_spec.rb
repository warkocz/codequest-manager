require 'spec_helper'

describe Transfer, type: :model do
  before do
    @user = create :user
    @other_user = create :other_user
    @transfer = build(:transfer) do |transfer|
      transfer.from = @user
      transfer.to = @other_user
    end
    @transfer.save!
  end
  it {should belong_to(:from)}
  it {should belong_to(:to)}
  it {should validate_presence_of(:to)}
  it {should validate_presence_of(:from)}

  describe '#mark_as_accepted!' do
    it 'should create new balance and change status' do
      expect(@transfer).to receive(:accepted!)
      user_balances = double('UserBalances')
      expect(@user).to receive(:user_balances).and_return(user_balances)
      expect(@user).to receive(:payer_balance).and_return(Money.new(500, 'PLN'))
      expect(user_balances).to receive(:create).with(balance: Money.new(2000, 'PLN'), payer: @other_user)
      @transfer.mark_as_accepted!
    end
  end
end