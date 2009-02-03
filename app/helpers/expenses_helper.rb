module ExpensesHelper
  # Determine which class name to use for the average of
  # the +expenses+ given over +unit+.
  def class_for_status_of(unit, expenses)
    expenses.is_above_average_for?(unit) ? 'above' : 'below'
  end
end