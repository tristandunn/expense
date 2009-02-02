class Expense < ActiveRecord::Base
  belongs_to :user

  validates_presence_of     :user_id
  validates_numericality_of :cost, :greater_than => 0
  validates_presence_of     :item

  # Find recent expenses, grouped by their relative date.
  def self.find_recent_grouped_by_relative_date(limit = 25)
    all(:order => 'created_at DESC', :limit => limit).group_by(&:relative_date)
  end

  # Determine the relative date from today.
  def relative_date
    case (Date.today - created_at.to_date)
    when 0         then 'Today'
    when 1         then 'Yesterday'
    when 2..6      then 'Last Week'
    when 7..13     then 'Two Weeks Ago'
    when 14..20    then 'Three Weeks Ago'
    when 21..29    then 'Four Weeks Ago'
    when 30..59    then 'Last Month'
    when 60..89    then 'Two Months Ago'
    when 90..119   then 'Three Months Ago'
    when 120..139  then 'Four Months Ago'
    when 140..364  then 'This Year'
    when 365..729  then 'Last Year'
    when 730..1094 then 'Two Years Ago'
    else                'Several Years Ago'
    end
  end
end