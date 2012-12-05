Given /^the following payments exist:$/ do |table|
  table.hashes.each do |hash|
    if attributes = Hash[*hash.delete("user").split(": ")]
      hash["user"] = User.where(attributes).first || create(:user, attributes)
    end

    create(:payment, hash)
  end
end

Then /^I should see a payment for ([\.\d]+) on "([^"]*)" from "([^"]*)"$/ do |cost, item, relative_date|
  should have_css("h3:contains('#{relative_date}')")
  should have_css(".payments li span",   text: item)
  should have_css(".payments li strong", text: cost)
end

Then /^I should not see a payment for ([\.\d]+) on "([^"]*)" from "([^"]*)"$/ do |cost, item, relative_date|
  should_not have_css("h3:contains('#{relative_date}')")
  should_not have_css(".payments li span:contains('#{item}')")
  should_not have_css(".payments li strong:contains('#{cost}')")
end

Then /^I should not see any payments$/ do
  all(".payments li").length.should == 0
end
