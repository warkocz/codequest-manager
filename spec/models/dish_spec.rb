require 'spec_helper'

describe Dish, :type => :model do
  it {should belong_to(:user)}
  it {should belong_to(:order)}
  it {should callback(:ensure_uniqueness).before(:create)}
  it {should validate_numericality_of(:price_cents)}
  it {should validate_presence_of(:price_cents)}
  it {should validate_presence_of(:name)}

  it 'should monetize price' do
    expect(monetize(:price_cents)).to be_truthy
  end

  describe '#ensure_uniqueness' do
    before do
      @user = create(:user)
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save
    end
    it 'should return true when new order and user' do
      dish = Dish.new user: @user, order: @order
      expect(dish.ensure_uniqueness).to be_truthy
    end
    it 'should return false when order and user are already connected' do
      previous_dish = create(:dish) do |dish|
        dish.user = @user
        dish.order = @order
      end
      previous_dish.save!
      dish = build(:dish) do |dish|
        dish.user = @user
        dish.order = @order
      end
      expect(dish.ensure_uniqueness).to be_falsey
    end
  end

  describe '#copy' do
    before do
      @user = create(:user)
      @other = create(:other_user)
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save
      @dish = build(:dish) do |dish|
        dish.user = @user
        dish.order = @order
      end
      @dish.save
    end
    it 'should return an instance of dish' do
      @new_dish = @dish.copy(@other)
      expect(@new_dish.user).to eq(@other)
      expect(@new_dish.name).to eq(@dish.name)
      expect(@new_dish.order).to eq(@order)
    end

    describe 'with existing dish'
    before do
      @existing_dish = build(:dish) do |dish|
        dish.user = @other
        dish.order = @order
      end
      @existing_dish.save
    end
    it 'should delete existing dish first' do
      expect {
        @new_dish = @dish.copy(@other)
      }.to change(Dish, :count).by(-1)
    end
  end

  describe '#subtract' do
    before do
      @user = create(:user)
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save
      @dish = build(:dish) do |dish|
        dish.user = @user
        dish.order = @order
        dish.price_cents = 1200
      end
      @dish.save
    end
    it 'should reduce users balance' do
      shipping = Money.new(1000, 'PLN')
      expect(@user).to receive(:subtract).with(Money.new(2200, 'PLN'), :payer)
      @dish.subtract shipping, :payer
    end
  end
end
