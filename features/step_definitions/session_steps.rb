Given /^I am signed in$/ do
  user = create(:user)

  step %{I sign in as "#{user.email} / #{user.password}"}
end

When /^I sign in as "(.*)\/(.*)"$/ do |email, password|
  step %{I go to the sign in page}
  step %{I fill in "E-mail" with "#{email.strip}"}
  step %{I fill in "Password" with "#{password.strip}"}
  step %{I press "Sign In"}
end

When /^I sign out$/ do
  step %{I follow "Sign Out"}
end

Then /^I should be signed in$/ do
  step %{I should see "Sign Out"}
end

Then /^I should be signed out$/ do
  step %{I should not see "Sign Out"}
end
