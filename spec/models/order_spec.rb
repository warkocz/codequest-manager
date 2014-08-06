require 'spec_helper'

describe Order, :type => :model do

  it {should belong_to(:orderer)}
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
end
