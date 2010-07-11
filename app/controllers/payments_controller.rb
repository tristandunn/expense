class PaymentsController < ApplicationController
  before_filter :load_payments_and_averages, :only => [:index, :search]

  def index
    @query = params[:query]

    if @query.present?
      @groups = @payments.search_grouped_by_relative_date(@query)
    else
      @groups = @payments.find_recent_grouped_by_relative_date
    end
  end

  def new
    @payment = current_user.payments.build
  end

  def create
    @payment = current_user.payments.build(params[:payment])
    @payment.save

    redirect_to root_url
  end

  protected

  def load_payments_and_averages
    @payments = current_user.payments
    @payment  = @payments.build
    @averages = {
      :day   => @payments.calculate_average_for(:day),
      :week  => @payments.calculate_average_for(:week),
      :month => @payments.calculate_average_for(:month)
    }
  end
end
