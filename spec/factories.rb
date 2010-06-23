Factory.define :payment do |payment|
  payment.association(:user)
  payment.cost { 299.99 }
  payment.item { 'iPhone' }
end

Factory.define :user do |user|
  user.sequence(:email)      { |n| "user#{n}@example.com" }
  user.password              { 'test' }
  user.password_confirmation { 'test' }
end
