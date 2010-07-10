Then /^I should be signed in$/ do
  Then %{I should see "Sign Out"}
end

Then /^I should not be signed in$/ do
  Then %{I should not see "Sign Out"}
end
