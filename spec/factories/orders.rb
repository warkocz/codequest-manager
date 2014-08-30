# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    date Date.today
    from 'The best restaurant'
    user nil
  end
end
