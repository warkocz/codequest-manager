require 'spec_helper'

describe OrderDecorator do
  describe '#dish_for_user' do
    before do
      @user = create(:user)
      @order = build(:order) do |order|
        order.orderer = @user
      end
      @order.save!
      @order = @order.decorate
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