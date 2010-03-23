class ExpensesController < ApplicationController
  def index
    load_expenses_and_averages

    @groups = @expenses.find_recent_grouped_by_relative_date
  end

  def new
    @expense = current_user.expenses.build
  end

  def create
    @expense = current_user.expenses.build(params[:expense])

    if @expense.save
      redirect_to '/'
    else
      respond_to do |format|
        format.html   { render :action => :new }
        format.iphone { redirect_to '/' }
      end
    end
  end

  def search
    load_expenses_and_averages

    @query  = params[:search][:query]
    @groups = Expense.search_grouped_by_relative_date(@query)
  end

  protected

  def load_expenses_and_averages
    @expense  = current_user.expenses.build
    @expenses = current_user.expenses
    @averages = {
      :day   => @expenses.calculate_average_for(:day),
      :week  => @expenses.calculate_average_for(:week),
      :month => @expenses.calculate_average_for(:month)
    }
  end
end
