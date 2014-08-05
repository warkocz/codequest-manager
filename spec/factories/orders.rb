# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    date "2014-08-05"
    orderer nil
  end
end
