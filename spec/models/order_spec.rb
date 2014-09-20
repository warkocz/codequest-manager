require 'spec_helper'

describe Order, :type => :model do

  it {should belong_to(:user)}
  it {should have_many(:dishes)}
  it {should callback(:ensure_one_order_per_day).before(:create)}
  it {should validate_presence_of(:user)}

  it 'should have statuses' do
    expect(Order.statuses).to eq({"in_progress"=>0, "ordered"=>1, "delivered"=>2})
  end

  describe '#ensure_one_order_per_day' do
    it 'should return true if no orders for the day' do
      expect(Order).to receive(:find_by).with(date: Date.today).and_return(nil)
      order = Order.new date: Date.today
      expect(order.ensure_one_order_per_day).to be_truthy
    end
    it 'should return false if there is order for the day' do
      mock = double('Order')
      expect(Order).to receive(:find_by).with(date: Date.today).and_return(mock)
      order = Order.new date: Date.today
      expect(order.ensure_one_order_per_day).to be_falsey
    end
  end

  describe '.todays_order' do
    it 'should call find' do
      mock = double('Order')
      expect(Order).to receive(:find_by).with(date: Date.today).and_return(mock)
      expect(Order.todays_order).to eq(mock)
    end
  end

  describe '#amout' do
    it 'should return 0 when no dishes' do
      order = Order.new date: Date.today
      expect(order).to receive(:dishes).and_return([])
      expect(order.amount).to eq(0)
    end

    it 'should return 15 when there is a dish' do
      order = Order.new date: Date.today
      dish = double('Dish')
      expect(dish).to receive(:price).and_return(Money.new(15,'PLN'))
      expect(order).to receive(:dishes).and_return([dish])
      expect(order.amount).to eq(Money.new(15,'PLN'))
    end
  end

  describe '#change_status!' do
    before do
      user = create(:user)
      @order = build(:order) do |order|
        order.user = user
      end
      @order.save
    end
    it 'should change from in_progress to ordered' do
      expect(@order).to_not receive(:subtract_price)
      @order.change_status!
      expect(@order.ordered?).to be_truthy
    end
    it 'should change from ordered to delivered' do
      @order.ordered!
      @order.save
      expect(@order).to receive(:subtract_price)
      @order.change_status!
      expect(@order.delivered?).to be_truthy
    end
    it 'should not change further' do
      @order.delivered!
      expect(@order).to_not receive(:subtract_price)
      @order.change_status!
      expect(@order.delivered?).to be_truthy
    end
  end

  describe '#subtract_price' do
    before do
      @user = create(:user)
      @order = build(:order) do |order|
        order.user = @user
        order.shipping = Money.new(2000, 'PLN')
      end
      @order.save
    end
    it 'should iterate over dishes and call #subtract' do
      dish1 = double('Dish')
      expect(dish1).to receive(:subtract).with(Money.new(1000, 'PLN'), @user)
      dish2 = double('Dish')
      expect(dish2).to receive(:subtract).with(Money.new(1000, 'PLN'), @user)
      allow(@order).to receive(:dishes_count).and_return(2)
      expect(@order).to receive(:dishes).and_return([dish1, dish2])
      @order.subtract_price
    end
  end
end
