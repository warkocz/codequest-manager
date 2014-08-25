require 'spec_helper'

describe DishDecorator do
  before do
    @user = create(:user)
    @dish = build(:dish) do |dish|
      dish.user = @user
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

end