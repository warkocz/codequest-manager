require 'spec_helper'

describe UserBalance, :type => :model do
  it {should belong_to(:user)}
  it 'should monetize balance' do
    expect(monetize(:balance_cents)).to be_truthy
  end
end
