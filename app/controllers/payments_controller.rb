class PaymentsController < ApplicationController
  before_action :find_payments, :build_payment

  def index
    @query    = params[:query]
    @payments = @payments.search(@query) if @query.present?
    @groups   = @payments.recent.group_by(&:relative_date)
  end

  def create
    @payment.attributes = payment_parameters
    @payment.save

    redirect_to root_url
  end

  protected

  def build_payment
    @payment = @payments.build
  end

  def find_payments
    @payments = current_user.payments
  end

  def payment_parameters
    params.require(:payment).permit(:item)
  end
end
