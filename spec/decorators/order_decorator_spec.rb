require 'spec_helper'

describe OrderDecorator do
  before do
    @user = create(:user)
    @order = build(:order) do |order|
      order.user = @user
    end
    @order.save!
    @order = @order.decorate
  end

  describe '#user_ordered?' do
    before do
      @other_user = create(:other_user)
      @dish = build(:dish) do |dish|
        dish.user = @other_user
        dish.order = @order
      end
      @dish.save!
    end

    it 'returns false when users differ' do
      expect(@order.user_ordered?(@user)).to be_falsey
    end

    it 'returns true when users do not differ' do
      expect(@order.user_ordered?(@other_user)).to eq(@dish)
    end
  end

  describe '#change_status_link' do
    it 'returns adequate when in_progress' do
      @order.in_progress!
      expect(@order.change_status_link).to match('Mark as ordered')
    end
    it 'returns adequate when ordered' do
      @order.ordered!
      expect(@order.change_status_link).to match('Mark as delivered')
    end
    it 'returns nil when delivered' do

    end
  end

end