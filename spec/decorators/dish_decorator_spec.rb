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
  end

  describe '#belongs_to?' do
    before do
      @other_user = create(:other_user)
    end

    it 'returns false when users differ' do
      expect(@dish.belongs_to?(@user)).to be_truthy
    end

    it 'returns true when users do not differ' do
      expect(@dish.belongs_to?(@other_user)).to be_falsey
    end
  end

  describe '#table_buttons' do
    it 'returns nil when order is delevered' do
      @order.delivered!
      expect(@dish.table_buttons(@user)).to be_nil
    end
    it 'returns adequate when dish belongs to a different_user' do
      @other_user = create :other_user
      expected = '<a data-confirm="This will overwrite your current dish! Are you sure\?" href="\/orders\/.*?\/dishes\/.*?\/copy">Copy</a>'
      expect(@dish.table_buttons(@other_user)).to match(expected)
    end
    describe 'with edit button' do
      before do
        @expected = '<a class="margin-right-small" href="\/orders\/.*?\/dishes\/.*?\/edit">Edit</a>'
      end
      it 'returns adequte when dish belongs to current_user and not in progress' do
        expect(@dish.table_buttons(@user)).to match(@expected)
      end
      it 'returns adequte when dish belongs to current_user and in progress' do
        @expected += '<a data-confirm="Are you sure\?" data-method="delete" href="\/orders\/.*?\/dishes\/.*?" rel="nofollow">Delete</a>'
        expect(@dish.table_buttons(@user)).to match(@expected)
      end
    end
  end
end