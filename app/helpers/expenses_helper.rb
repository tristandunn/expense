module ExpensesHelper
  def class_for_status_of(unit, expenses)
    expenses.is_above_average_for?(unit) ? 'above' : 'below'
  end
end
