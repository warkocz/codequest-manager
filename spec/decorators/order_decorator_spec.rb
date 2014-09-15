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

  describe '#ordered_by?' do
    it 'returns true when user is the orderer' do
      expect(@order.ordered_by?(@user)).to be_truthy
    end
    it 'returns false otherwise' do
      other_user = create :other_user
      expect(@order.ordered_by?(other_user)).to be_falsey
    end
  end

  describe '#summary_buttons' do
    describe 'when delivered' do
      before do
        @order.delivered!
      end
      it 'returns adequate ordered by current user' do
        expect(@order).to receive(:ordered_by?).with(@user).and_return(true)
        expect(@order).to receive(:change_status_link).and_return('<a></a>')
        expect(@order.summary_buttons(@user)).to eq('<a></a>')
      end
      it 'returns adequate ordered by other user' do
        expect(@order).to receive(:ordered_by?).with(@user).and_return(false)
        expect(@order).to_not receive(:change_status_link)
        expect(@order.summary_buttons(@user)).to eq('')
      end
    end
    describe 'when not delivered' do
      it 'returns adequate ordered by current user' do
        expect(@order).to receive(:ordered_by?).with(@user).and_return(true)
        expect(@order).to receive(:change_status_link).and_return('<a></a>')
        expected = '<a class=\"button\" href=\"/orders/.*?/edit\">Change payer</a><a></a>'
        expect(@order.summary_buttons(@user)).to match(expected)
      end
      it 'returns adequate ordered by other user' do
        expect(@order).to receive(:ordered_by?).with(@user).and_return(false)
        expect(@order).to_not receive(:change_status_link)
        expected = '<a class="button" href="/orders/.*?/edit">Change payer</a>'
        expect(@order.summary_buttons(@user)).to match(expected)
      end
    end
  end
end