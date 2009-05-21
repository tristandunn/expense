require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExpensesController do
  before do
    user_is_valid

    @expenses = mock('Expenses')

    @user.stub!(:expenses).and_return(@expenses)
  end

  describe 'on GET to index' do
    before do
      @groups  = mock('Groups')
      @expense = mock('Expense')
      @expenses.stub!(:build).and_return(@expense)
      @expenses.stub!(:calculate_average_for)
      @expenses.stub!(:find_recent_grouped_by_relative_date).and_return(@groups)
    end

    it 'should assign new expense' do
      do_get
      assigns[:expense].should == @expense
    end

    it 'should group recent expenses' do
      @expenses.should_receive(:find_recent_grouped_by_relative_date)
      do_get
    end

    it 'should assign expenses' do
      do_get
      assigns[:expenses].should == @expenses
    end

    it 'should assign groups' do
      do_get
      assigns[:groups].should == @groups
    end

    [:day, :week, :month].each do |unit|
      it "should calculate average for #{unit}s" do
        @expenses.should_receive(:calculate_average_for).with(unit)
        do_get
      end
    end

    it 'should render index' do
      do_get
      response.should render_template('expenses/index')
    end

    protected

    def do_get
      get :index
    end
  end

  describe 'on GET to new' do
    before do
      @expense = mock('Expense')
      @expenses.stub!(:build).and_return(@expense)
    end

    it 'should assign new expense' do
      do_get
      assigns[:expense].should == @expense
    end

    it 'should render new' do
      do_get
      response.should render_template('expenses/new')
    end

    protected

    def do_get
      get :new
    end
  end

  describe 'on POST to create' do
    before do
      @expense = mock('Expense')
      @expense.stub!(:save)

      @expenses.stub!(:build).and_return(@expense)
    end

    it 'should build a new expense' do
      @expenses.should_receive(:build).with(hash_including(valid_attributes))
      do_post
    end

    it 'should attempt to save expense' do
      @expense.should_receive(:save)
      do_post
    end

    describe 'with valid attributes' do
      before do
        @expense.stub!(:save).and_return(true)
      end

      it 'should redirect' do
        do_post
        response.should redirect_to('/')
      end
    end

    describe 'with invalid attributes' do
      before do
        @expense.stub!(:save).and_return(false)
      end

      it 'should assign new expense' do
        do_post
        assigns[:expense].should == @expense
      end

      it 'should render "expenses/new" template' do
        do_post
        response.should render_template('expenses/new')
      end

      describe 'for iPhone request' do
        before do
          request.env['HTTP_USER_AGENT'] = 'Mobile/1.0 Safari'
        end

        it 'should redirect' do
          do_post
          response.should redirect_to('/')
        end
      end
    end

    protected

    def do_post
      post :create,
           :expense => valid_attributes
    end

    def valid_attributes
      { :cost => 1.00,
        :item => 'a lottery ticket'
      }
    end
  end

  describe 'on GET to search' do
    before do
      @groups  = mock('Groups')
      @expense = mock('Expense')
      @expenses.stub!(:build).and_return(@expense)
      @expenses.stub!(:calculate_average_for)

      Expense.stub!(:search_grouped_by_relative_date).and_return(@groups)
    end

    it 'should assign new expense' do
      do_get
      assigns[:expense].should == @expense
    end

    it 'should search for expenses and group results' do
      Expense.should_receive(:search_grouped_by_relative_date)
      do_get
    end

    it 'should assign expenses' do
      do_get
      assigns[:expenses].should == @expenses
    end

    it 'should assign groups' do
      do_get
      assigns[:groups].should == @groups
    end

    it 'should assign query' do
      do_get
      assigns[:query].should == 'test'
    end

    [:day, :week, :month].each do |unit|
      it "should calculate average for #{unit}s" do
        @expenses.should_receive(:calculate_average_for).with(unit)
        do_get
      end
    end

    it 'should render search' do
      do_get
      response.should render_template('expenses/search')
    end

    protected

    def do_get
      get :search,
          :search => {
            :query => 'test'
          }
    end
  end
end