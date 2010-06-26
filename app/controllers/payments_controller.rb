class PaymentsController < ApplicationController
  before_filter :load_payments_and_averages, :only => [:index, :search]

  def index
    @groups = @payments.find_recent_grouped_by_relative_date
  end

  def new
    @payment = current_user.payments.build
  end

  def create
    @payment = current_user.payments.build(params[:payment])

    if @payment.save
      redirect_to root_url
    else
      respond_to do |format|
        format.html   { render :action => :new }
        format.iphone { redirect_to root_url }
      end
    end
  end

  def search
    @query  = params[:search][:query]
    @groups = Payment.search_grouped_by_relative_date(@query)
  end

  protected

  def load_payments_and_averages
    @payment  = current_user.payments.build
    @payments = current_user.payments
    @averages = {
      :day   => @payments.calculate_average_for(:day),
      :week  => @payments.calculate_average_for(:week),
      :month => @payments.calculate_average_for(:month)
    }
  end
end
