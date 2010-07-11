Then /^I should see a payment for ([\.\d]+) on "([^"]*)" from "([^"]*)"$/ do |cost, item, relative_date|
  within('h3') do
    should have_content(relative_date)
  end

  within('li') do
    should have_css('span',   :content => item)
    should have_css('strong', :content => cost)
  end
end

Then /^I should not see a payment for ([\.\d]+) on "([^"]*)" from "([^"]*)"$/ do |cost, item, relative_date|
  within('h3') do
    should_not have_content(relative_date)
  end

  within('li') do
    within('span') do
      should_not have_content(item)
    end

    within('strong') do
      should_not have_content(cost)
    end
  end
end

Then /^I should not see any payments$/ do
  all('.payments li').length.should == 0
end
