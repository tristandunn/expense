Given /^I am signed in$/ do
  user = Factory(:user)

  And %{I sign in as "#{user.email} / #{user.password}"}
end

When /^I sign in as "(.*)\/(.*)"$/ do |email, password|
  When %{I go to the sign in page}
  And %{I fill in "E-mail" with "#{email.strip}"}
  And %{I fill in "Password" with "#{password.strip}"}
  And %{I press "Sign In"}
end

When /^I sign out$/ do
  And %{I follow "Sign Out"}
end

Then /^I should be signed in$/ do
  Then %{I should see "Sign Out"}
end

Then /^I should be signed out$/ do
  Then %{I should not see "Sign Out"}
end
