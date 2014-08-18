require 'spec_helper'

describe Dish, :type => :model do
  it {should belong_to(:user)}
  it {should belong_to(:order)}
  it {should callback(:ensure_uniqueness).before(:create)}
  it {should validate_numericality_of(:price)}
  it {should validate_presence_of(:price)}
  it {should validate_presence_of(:name)}

  describe '#ensure_uniqueness' do
    before do
      @user = create(:user)
      @order = build(:order) do |order|
        order.orderer = @user
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
end
