class Payment < ActiveRecord::Base
  belongs_to :user

  before_validation :extract_cost_from_item

  validates_presence_of     :user_id
  validates_numericality_of :cost, :greater_than => 0
  validates_presence_of     :item

  scope :recent, order('created_at DESC').limit(25)
  scope :search, lambda { |query| where('item LIKE ?', "%#{query}%") }

  def self.grouped_by_relative_date
    all.group_by(&:relative_date)
  end

  def relative_date
    case (Time.zone.now.to_date - created_at.to_date)
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

  def extract_cost_from_item
    return unless cost.nil?

    if /^[$]?(\d*\.\d{1,2}|\d+)\s*(?:on|for)*\s+(.*)$/.match(item)
      self.cost = $1
      self.item = $2
    end
  end
end
