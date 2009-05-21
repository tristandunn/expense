class ExpensesController < ApplicationController
  before_filter :find_expenses,      :only => %w(index)
  before_filter :build_expense,      :only => %w(index)
  before_filter :calculate_averages, :only => %w(index)

  # List recent expenses.
  def index
    @groups = @expenses.find_recent_grouped_by_relative_date
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
      respond_to do |format|
        format.html   { render :action => :new }
        format.iphone { redirect_to '/' }
      end
    end
  end

  protected

  # Build an expense for the current user.
  def build_expense
    @expense = current_user.expenses.build
  end

  # Calculate daily, weekly and monthly averages.
  def calculate_averages
    @averages = {
      :day   => @expenses.calculate_average_for(:day),
      :week  => @expenses.calculate_average_for(:week),
      :month => @expenses.calculate_average_for(:month)
    }
  end

  # Find current users expenses.
  def find_expenses
    @expenses = current_user.expenses
  end
end