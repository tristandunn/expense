class PaymentsController < ApplicationController
  before_filter :find_payments, :build_payment

  def index
    @query    = params[:query]
    @payments = @payments.search(@query) if @query.present?
    @groups   = @payments.recent.group_by(&:relative_date)
  end

  def create
    @payment.attributes = params[:payment]
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
end
