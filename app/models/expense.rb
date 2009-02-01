class Expense < ActiveRecord::Base
  belongs_to :user

  validates_presence_of     :user_id
  validates_numericality_of :cost, :greater_than => 0
  validates_presence_of     :item
end