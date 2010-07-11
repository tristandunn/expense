Given /^the date is "([^"]*)"$/ do |date|
  Timecop.freeze(Time.parse(date))
end
