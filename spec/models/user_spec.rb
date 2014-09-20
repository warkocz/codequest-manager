require 'spec_helper'

describe User do
  it {should have_many(:orders)}
  it {should have_many(:user_balances)}
  it {should callback(:add_first_balance).after(:create)}

  describe '#balances' do
    before do
      @user = create(:user)
      @payer = create(:other_user)
      @balance_one = build(:user_balance) do |balance|
        balance.user = @user
        balance.payer = @payer
        balance.balance = 15
      end
      @balance_one.save!
      @balance_two = build(:user_balance) do |balance|
        balance.user = @user
        balance.payer = @payer
        balance.balance = 17
      end
      @balance_two.save!
      @balance_three = build(:user_balance) do |balance|
        balance.user = @user
        balance.payer = @user
        balance.balance = 34
      end
      @balance_three.save!
    end
    it 'should return adequate' do
      # puts @user.balances
      expect(UserBalance).to receive(:balances_for).with(@user).and_return([@balance_two, @balance_three])
      balances = @user.balances
      expect(balances.count).to be(2)
      # expect(@user.balances.balance_cents).to_not be(1500)
      # expect(@user.balances.balance_cents).to be(1700)
    end
  end

  describe '#add_first_balance' do
    before do
      @user = User.new
    end
    it 'should create a user_balance' do
      balances = double('UserBalances')
      expect(balances).to receive(:create).with({balance: 0, payer: @user})
      expect(@user).to receive(:user_balances).and_return(balances)
      @user.add_first_balance
    end
  end

  describe 'subtract' do
    before do
      @user = create(:user)
      @payer = create(:other_user)
    end
    it 'add a new reduced user balance' do
      money = Money.new 1200, 'PLN'
      expect(@user).to receive(:payer_balance).with(@payer).and_return(Money.new(5000,'PLN'))
      expect {@user.subtract(money, @payer)}.to change(@user.user_balances, :count).by(1)
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

  describe '#payer_balance' do
    before do
      @user = create :user
    end
    it 'calls scope method' do
      payer = double('Payer')
      expect(payer).to receive(:id).and_return(5)
      user_balances = double('UserBalances')
      balance = double('UserBalance')
      newest_for_payer = double('UserBalance')
      expect(newest_for_payer).to receive(:balance).and_return(balance)
      expect(user_balances).to receive(:newest_for).with(5).and_return(newest_for_payer)
      expect(@user).to receive(:user_balances).and_return(user_balances)
      expect(@user.payer_balance(payer)).to eq(balance)
    end
  end

  describe '#total_balance' do
    before do
      @user = create :user
      other_user = create :other_user
      @balance_one = build :user_balance do |b|
        b.user = @user
        b.payer = @user
        b.balance = 10
      end
      @balance_two = build :user_balance do |b|
        b.user = @user
        b.payer = other_user
        b.balance = 40
      end
      expect(@user).to receive(:balances).and_return([@balance_one, @balance_two])
    end
    it 'returns proper balance' do
      money = Money.new 5000, 'PLN'
      expect(@user.total_balance).to eq(money)
    end
  end
end
