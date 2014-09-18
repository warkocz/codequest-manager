require 'spec_helper'

describe User do
  it {should have_many(:orders)}
  it {should have_many(:user_balances)}
  it {should callback(:add_first_balance).after(:create)}

  describe '#balance' do
    before do
      @user = create(:user)
      @balance_one = build(:user_balance) do |balance|
        balance.user = @user
        balance.balance = 15
      end
      @balance_one.save
      @balance_two = build(:user_balance) do |balance|
        balance.user = @user
        balance.balance = 17
      end
      @balance_two.save
    end
    it 'should return adequate' do
      expect(@user.balance.balance_cents).to_not be(1500)
      expect(@user.balance.balance_cents).to be(1700)
    end
  end

  describe '#add_first_balance' do
    before do
      @user = create(:user)
    end
    it 'should create a user_balance' do
      expect {@user.add_first_balance}.to change(@user.user_balances, :count).by(1)
    end
  end

  describe 'subtract' do
    before do
      @user = create(:user)
      @user.user_balances.create(balance_cents: 5000)
    end
    it 'add a new reduced user balance' do
      money = Money.new(1200,'PLN')
      expect {@user.subtract(money)}.to change(@user.user_balances, :count).by(1)
      expect(@user.balance.balance).to eq(Money.new(3800,'PLN'))
    end
  end

  describe '#to_s' do
    before do
      @user = create(:user)
    end
    it 'should call name' do
      expect(@user).to receive(:name).and_return('mock name')
      expect(@user.to_s).to eq('mock name')
    end
  end
end
