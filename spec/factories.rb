FactoryGirl.define do
  factory :payment do
    association(:user)
    cost { 299.99 }
    item { 'iPhone' }
  end

  factory :user do
    sequence(:email)      { |n| "user#{n}@example.com" }
    password              { 'test' }
    password_confirmation { 'test' }
  end
end
