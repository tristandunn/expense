class ExpensesController < ApplicationController
  # List recent expenses.
  def index
    @expense  = current_user.expenses.build
    @expenses = current_user.expenses.find_recent_grouped_by_relative_date
    @averages = {
      :day   => current_user.expenses.calculate_average_for(:day),
      :week  => current_user.expenses.calculate_average_for(:week),
      :month => current_user.expenses.calculate_average_for(:month)
    }
  end

  # Display new expense form.
  def new
    @expense = current_user.expenses.build
  end

  # Attempt to create an expense.
  #
  # If successful redirect, otherwise display the new
  # expense form.
  def create
    @expense = current_user.expenses.build(params[:expense])

    if @expense.save
      redirect_to '/'
    else
      render :action => :new
    end
  end
end