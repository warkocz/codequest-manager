require 'spec_helper'

describe TransferDecorator do
  before do
    @user = create :user
    @other_user = create :other_user
    @transfer = build(:transfer) do |transfer|
      transfer.from = @user
      transfer.to = @other_user
    end
    @transfer.save!
    @transfer = @transfer.decorate
  end

  describe '#actions' do
    it 'calls adequate methods' do
      expect(@transfer).to receive(:accept_button).and_return('accept')
      expect(@transfer.actions).to eq('accept')
    end
  end

  describe '#accept_button' do
    describe 'when pending' do
      it 'returns a button' do
        expected = '<a data-confirm="Are you sure\?" data-method="put" href="\/transfers\/.*?" rel="nofollow">Accept</a>'
        expect(@transfer.accept_button).to match(expected)
      end
    end
    describe 'otherwise' do

    end
  end
end