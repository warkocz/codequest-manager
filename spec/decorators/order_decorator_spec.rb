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

  describe '#current_user_ordered?' do
    before do
      @other_user = create(:other_user)
      @dish = build(:dish) do |dish|
        dish.user = @other_user
        dish.order = @order
      end
      @dish.save!
    end

    it 'returns false when users differ' do
      sign_in @user
      expect(@order.current_user_ordered?).to be_falsey
    end

    it 'returns true when users do not differ' do
      sign_in @other_user
      expect(@order.current_user_ordered?).to eq(@dish)
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

  describe '#ordered_by_current_user?' do
    it 'returns true when user is the orderer' do
      sign_in @user
      expect(@order.ordered_by_current_user?).to be_truthy
    end
    it 'returns false otherwise' do
      other_user = create :other_user
      sign_in other_user
      expect(@order.ordered_by_current_user?).to be_falsey
    end
  end

  describe '#summary_buttons' do
    describe 'when delivered' do
      before do
        @order.delivered!
      end
      it 'returns adequate ordered by current user' do
        expect(@order).to receive(:ordered_by_current_user?).and_return(true)
        expect(@order).to receive(:change_status_link).and_return('')
        expect(@order.summary_buttons).to eq('')
      end
      it 'returns adequate ordered by other user' do
        expect(@order).to receive(:ordered_by_current_user?).and_return(false)
        expect(@order).to_not receive(:change_status_link)
        expect(@order.summary_buttons).to eq('')
      end
    end
    describe 'when in progress' do
      it 'returns adequate ordered by current user' do
        expect(@order).to receive(:ordered_by_current_user?).and_return(true)
        expect(@order).to receive(:change_status_link).and_return('Mark as ordered')
        expected = 'href=\"/orders/.*?/edit\".*?Change payer.*?Mark as ordered'
        expect(@order.summary_buttons).to match(expected)
      end
      it 'returns adequate ordered by other user' do
        expect(@order).to receive(:ordered_by_current_user?).and_return(false)
        expect(@order).to_not receive(:change_status_link)
        expected = 'href="/orders/.*?/edit".*?Change payer'
        expect(@order.summary_buttons).to match(expected)
      end
    end
    describe 'when ordered' do
      before do
        @order.ordered!
      end
      it 'returns adequate ordered by current user' do
        expect(@order).to receive(:ordered_by_current_user?).twice.and_return(true)
        expect(@order).to receive(:change_status_link).and_return('Mark as Delivered')
        expected = 'href="/orders/.*?/edit".*?Change payer.*?href="/orders/.*?/shipping".*?Add shipping.*?Mark as Delivered'
        expect(@order.summary_buttons).to match(expected)
      end
      it 'returns adequate ordered by other user' do
        expect(@order).to receive(:ordered_by_current_user?).twice.and_return(false)
        expect(@order).to_not receive(:change_status_link)
        expected = 'href="/orders/.*?/edit".*?Change payer'
        expect(@order.summary_buttons).to match(expected)
      end
    end
  end
end