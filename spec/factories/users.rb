FactoryGirl.define do
  factory :user do |user|
    user.email 'bartek@test.net'
    user.password 'jacekjacek'
  end

  factory :other_user, class: User do |user|
    user.email 'krus@test.net'
    user.password 'password'
  end
end