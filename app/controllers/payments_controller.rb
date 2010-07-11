class PaymentsController < ApplicationController
  def index
    @query    = params[:query]
    @payments = current_user.payments
    @payment  = @payments.build
    @averages = @payments.calculate_averages_over_time

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
end
