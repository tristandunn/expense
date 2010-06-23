module PaymentsHelper
  def class_for_status_of(unit, payments)
    payments.is_above_average_for?(unit) ? 'above' : 'below'
  end
end
