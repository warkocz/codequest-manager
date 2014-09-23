require 'spec_helper'

describe Transfer, type: :model do
  it {should belong_to(:from)}
  it {should belong_to(:to)}
  it {should validate_presence_of(:to)}
  it {should validate_presence_of(:from)}
end