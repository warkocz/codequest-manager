require 'spec_helper'

describe Order, :type => :model do

  it {should belong_to(:orderer)}
  it {should have_many(:dishes)}
  it {should callback(:ensure_one_order_per_day).before(:create)}
  it {should validate_presence_of(:orderer)}

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
      expect(dish).to receive(:price).and_return(15.0)
      expect(order).to receive(:dishes).and_return([dish])
      expect(order.amount).to eq(15.0)
    end
  end

  describe '#dish_for_user' do
    before do
      @user = create(:user)
      @order = build(:order) do |order|
        order.orderer = @user
      end
      @order.save!
    end
    it 'should return nil when no dish' do
      expect(@order.dish_for_user(@user)).to be_nil
    end
    it 'should return a dish' do
      dish = create(:dish) do |dish|
        dish.user = @user
        dish.order = @order
      end
      dish.save!
      expect(@order.dish_for_user(@user)).to eq(dish)
    end
  end
end
