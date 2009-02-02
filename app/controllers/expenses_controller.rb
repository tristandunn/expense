class ExpensesController < ApplicationController
  # List recent expenses.
  def index
    @expenses = current_user.expenses.find_recent_grouped_by_relative_date
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