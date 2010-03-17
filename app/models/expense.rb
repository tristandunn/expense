class Expense < ActiveRecord::Base
  belongs_to :user

  before_validation :extract_cost_from_item

  validates_presence_of     :user_id
  validates_numericality_of :cost, :greater_than => 0
  validates_presence_of     :item

  def self.calculate_average_for(unit)
    find_averages_for(unit).sum / determine_duration_since_first_entry_in(unit).to_f
  end

  def self.is_above_average_for?(unit)
    return false unless first = first(:order => 'created_at ASC')

    find_averages_for(unit).first > calculate_average_for(unit)
  end

  def self.find_averages_for(unit)
    all(:order => 'created_at DESC').group_by do |expense|
      expense.created_at.strftime(determine_format_for(unit))
    end.collect do |group, expenses|
      (expenses.collect(&:cost).sum / expenses.length).round(2)
    end
  end

  def self.find_recent_grouped_by_relative_date(limit = 25)
    all(:order => 'created_at DESC', :limit => limit).group_by(&:relative_date)
  end

  def self.search(query)
    all(:conditions => ['item LIKE ?', "%#{query}%"], :order => 'created_at DESC')
  end

  def self.search_grouped_by_relative_date(query)
    search(query).group_by(&:relative_date)
  end

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

  protected

  def self.determine_format_for(unit)
    case unit
    when :day   then '%j%Y'
    when :week  then '%W%Y'
    when :month then '%m%Y'
    end
  end

  def self.determine_duration_since_first_entry_in(unit)
    return 1 unless first = first(:order => 'created_at ASC')

    duration = case unit
               when :day   then 1.day
               when :week  then 7.days
               when :month then 30.days
               end

    [1, (Time.now.to_f - first.created_at.to_f) / duration].max
  end

  def extract_cost_from_item
    return unless cost.nil?

    if /^[$]?(\d*\.\d{1,2}|\d+)\s*(on|for)*\s+(.*)$/.match(item)
      self.cost = $1
      self.item = $3
    end
  end
end
