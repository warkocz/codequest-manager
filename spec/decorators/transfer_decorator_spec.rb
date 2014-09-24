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
      expect(@transfer).to receive(:reject_button).and_return('reject')
      expect(@transfer.actions).to eq('acceptreject')
    end
  end

  describe '#accept_button' do
    describe 'when pending' do
      it 'returns a button' do
        expected = '<a data-confirm="Are you sure\?" data-method="put" href="\/transfers\/.*?/accept" rel="nofollow">Accept</a>'
        expect(@transfer.accept_button).to match(expected)
      end
    end
    describe 'otherwise' do
      it 'returns nil when accepted' do
        @transfer.accepted!
        expect(@transfer.accept_button).to be_nil
      end
      it 'returns nil when rejected' do
        @transfer.rejected!
        expect(@transfer.accept_button).to be_nil
      end
    end
  end

  describe '#reject_button' do
    describe 'when pending' do
      it 'returns a button' do
        expected = '<a data-confirm="The transfer will be rejected\! Are you sure\?" data-method="put" href="\/transfers\/.*?/reject" rel="nofollow">Reject</a>'
        expect(@transfer.reject_button).to match(expected)
      end
    end
    describe 'otherwise' do
      it 'returns nil when accepted' do
        @transfer.accepted!
        expect(@transfer.reject_button).to be_nil
      end
      it 'returns nil when rejected' do
        @transfer.rejected!
        expect(@transfer.reject_button).to be_nil
      end
    end
  end
end