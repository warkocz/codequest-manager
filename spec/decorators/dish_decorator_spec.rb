require 'spec_helper'

describe DishDecorator do
  before do
    @user = create(:user)
    @order = build(:order) do |order|
      order.user = @user
    end
    @order.save
    @dish = build(:dish) do |dish|
      dish.user = @user
      dish.order = @order
    end
    @dish.save!
    @dish = @dish.decorate
    allow(@dish).to receive(:current_user).and_return(@user)
    @other_user = create :other_user
  end

  describe '#belongs_to_current_user?' do
    it 'returns false when users differ' do
      expect(@dish.belongs_to_current_user?).to be_truthy
    end

    it 'returns true when users do not differ' do
      allow(@dish).to receive(:current_user).and_return(@other_user)
      expect(@dish.belongs_to_current_user?).to be_falsey
    end
  end

  describe '#table_buttons' do
    it 'calls necessary methods' do
      expect(@dish).to receive(:edit_button).and_return('edit_button')
      expect(@dish).to receive(:delete_button).and_return('delete_button')
      expect(@dish).to receive(:copy_button).and_return('copy_button')
      expect(@dish.table_buttons).to eq('edit_buttondelete_buttoncopy_button')
    end
    it 'works well with nils' do
      expect(@dish).to receive(:edit_button).and_return(nil)
      expect(@dish).to receive(:delete_button).and_return(nil)
      expect(@dish).to receive(:copy_button).and_return(nil)
      expect(@dish.table_buttons).to eq('')
    end
  end

  describe '#edit_button' do
    it 'returns nil when dish belongs to different user' do
      allow(@dish).to receive(:current_user).and_return(@other_user)
      expect(@dish.edit_button).to be_nil
    end
    it 'returns nil when order is delivered' do
      @order.delivered!
      expect(@dish.edit_button).to be_nil
    end
    describe 'otherwise' do
      before do
        @expected = '<a class="margin-right-small" href="\/orders\/.*?\/dishes\/.*?\/edit">Edit</a>'
      end
      it 'returns button when order is in_progress' do
        expect(@dish.edit_button).to match(@expected)
      end
      it 'returns button when order is ordered' do
        expect(@dish.edit_button).to match(@expected)
      end
    end
  end

  describe '#delete_button' do
    it 'returns nil when dish belongs to different user' do
      allow(@dish).to receive(:current_user).and_return(@other_user)
      expect(@dish.delete_button).to be_nil
    end
    it 'returns button when order is in_progress' do
      expected = '<a data-confirm="Are you sure\?" data-method="delete" href="\/orders\/.*?\/dishes\/.*?" rel="nofollow">Delete</a>'
      expect(@dish.delete_button).to match(expected)
    end
    describe 'otherwise' do
      it 'returns nil when order is ordered' do
        @order.ordered!
        expect(@dish.delete_button).to be_nil
      end
      it 'returns nil when order is delivered' do
        @order.delivered!
        expect(@dish.delete_button).to be_nil
      end
    end
  end

  describe '#copy_button' do
    describe 'order is in_progress' do
      it 'returns nil if dish belongs to current user' do
        expect(@dish.copy_button).to be_nil
      end
      it 'returns button when not' do
        allow(@dish).to receive(:current_user).and_return(@other_user)
        expected = '<a data-confirm="This will overwrite your current dish! Are you sure\?" href="\/orders\/.*?\/dishes\/.*?\/copy">Copy</a>'
        expect(@dish.copy_button).to match(expected)
      end
    end
    describe 'otherwise' do
      it 'returns nil when order is ordered' do
        @order.ordered!
        expect(@dish.copy_button).to be_nil
      end
      it 'returns nil when order is delivered' do
        @order.delivered!
        expect(@dish.copy_button).to be_nil
      end
    end
  end
end