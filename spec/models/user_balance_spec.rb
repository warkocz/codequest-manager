require 'spec_helper'

describe UserBalance, :type => :model do
  it {should belong_to(:user)}
  it {should belong_to(:payer)}
  it {should validate_presence_of(:user)}
  it {should validate_presence_of(:payer)}
  it 'should monetize balance' do
    expect(monetize(:balance_cents)).to be_truthy
  end

  describe '.balances_for' do
    before do
      @user = create :user
      @other_user = create :other_user
      @balance_one = build :user_balance do |b|
        b.user = @user
        b.payer = @user
        b.balance = 10
      end
      @balance_one.save!
      @balance_two = build :user_balance do |b|
        b.user = @user
        b.payer = @other_user
        b.balance = 40
      end
      @balance_two.save!
      @balance_three = build :user_balance do |b|
        b.user = @user
        b.payer = @other_user
        b.balance = 40
      end
      @balance_three.save!
      @balance_four = build :user_balance do |b|
        b.user = @user
        b.payer = @user
        b.balance = 40
      end
      @balance_four.save!
      @balance_five = build :user_balance do |b|
        b.user = @other_user
        b.payer = @other_user
        b.balance = 40
      end
      @balance_five.save!
    end
    it 'should call adequate methods' do
      expect(UserBalance).to receive(:payers_ids).with(@user).and_return([@user.id, @other_user.id])
      expect(UserBalance.balances_for(@user)).to contain_exactly(@balance_four, @balance_three)
    end
  end

  describe '.payers_ids' do
    before do
      @user = create :user
      @other_user = create :other_user
      @balance_one = build :user_balance do |b|
        b.user = @user
        b.payer = @user
        b.balance = 10
      end
      @balance_one.save!
      @balance_two = build :user_balance do |b|
        b.user = @user
        b.payer = @other_user
        b.balance = 40
      end
      @balance_two.save!
      @balance_three = build :user_balance do |b|
        b.user = @user
        b.payer = @other_user
        b.balance = 40
      end
      @balance_three.save!
      @balance_four = build :user_balance do |b|
        b.user = @user
        b.payer = @user
        b.balance = 40
      end
      @balance_four.save!
      @balance_five = build :user_balance do |b|
        b.user = @other_user
        b.payer = @other_user
        b.balance = 40
      end
      @balance_five.save!
    end
    it 'returns adequate ids' do
      expect(UserBalance.payers_ids(@user)).to contain_exactly(@other_user.id, @user.id)
    end
  end
end
