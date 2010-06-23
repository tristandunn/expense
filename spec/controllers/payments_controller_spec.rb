require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PaymentsController do
  before do
    user_is_valid

    @payment = mock('Payment')
    @payments = mock('Payments')
    @payments.stub!(:build).and_return(@payment)
    @payments.stub!(:calculate_average_for)

    @user.stub!(:payments).and_return(@payments)
  end

  describe 'on GET to index' do
    before do
      @groups = mock('Groups')
      @payments.stub!(:find_recent_grouped_by_relative_date).and_return(@groups)
    end

    it 'should load payments and calculate averages' do
      controller.instance_variable_set('@payments', @payments)
      controller.should_receive(:load_payments_and_averages)
      do_get
    end

    it 'should group recent payments' do
      @payments.should_receive(:find_recent_grouped_by_relative_date)
      do_get
    end

    it 'should assign new payment' do
      do_get
      assigns[:payment].should == @payment
    end

    it 'should assign payments' do
      do_get
      assigns[:payments].should == @payments
    end

    it 'should assign groups' do
      do_get
      assigns[:groups].should == @groups
    end

    it 'should render index' do
      do_get
      response.should render_template('payments/index')
    end

    protected

    def do_get
      get :index
    end
  end

  describe 'on GET to new' do
    it 'should assign new payment' do
      do_get
      assigns[:payment].should == @payment
    end

    it 'should render new' do
      do_get
      response.should render_template('payments/new')
    end

    protected

    def do_get
      get :new
    end
  end

  describe 'on POST to create' do
    before do
      @payment.stub!(:save)
    end

    it 'should build a new payment' do
      @payments.should_receive(:build).with(hash_including(valid_attributes))
      do_post
    end

    it 'should attempt to save payment' do
      @payment.should_receive(:save)
      do_post
    end

    describe 'with valid attributes' do
      before do
        @payment.stub!(:save).and_return(true)
      end

      it 'should redirect' do
        do_post
        response.should redirect_to(root_url)
      end
    end

    describe 'with invalid attributes' do
      before do
        @payment.stub!(:save).and_return(false)
      end

      it 'should assign new payment' do
        do_post
        assigns[:payment].should == @payment
      end

      it 'should render "payments/new" template' do
        do_post
        response.should render_template('payments/new')
      end

      describe 'for iPhone request' do
        before do
          request.env['HTTP_USER_AGENT'] = 'AppleWebKit Mobile'
        end

        it 'should redirect' do
          do_post
          response.should redirect_to(root_url)
        end
      end
    end

    protected

    def do_post
      post :create,
           :payment => valid_attributes
    end

    def valid_attributes
      { :cost => 1.00,
        :item => 'a lottery ticket'
      }
    end
  end

  describe 'on GET to search' do
    before do
      @groups = mock('Groups')

      Payment.stub!(:search_grouped_by_relative_date).and_return(@groups)
    end

    it 'should load payments and calculate averages' do
      controller.instance_variable_set('@payments', @payments)
      controller.should_receive(:load_payments_and_averages)
      do_get
    end

    it 'should search for payments and group results' do
      Payment.should_receive(:search_grouped_by_relative_date)
      do_get
    end

    it 'should assign new payment' do
      do_get
      assigns[:payment].should == @payment
    end

    it 'should assign payments' do
      do_get
      assigns[:payments].should == @payments
    end

    it 'should assign groups' do
      do_get
      assigns[:groups].should == @groups
    end

    it 'should assign query' do
      do_get
      assigns[:query].should == 'test'
    end

    it 'should render search' do
      do_get
      response.should render_template('payments/search')
    end

    protected

    def do_get
      get :search,
          :search => {
            :query => 'test'
          }
    end
  end

  describe 'when loading payments and averages' do
    it 'should build a new payment' do
      @payments.should_receive(:build)
      controller.send(:load_payments_and_averages)
    end

    it 'should retrieve the current users payments' do
      @user.should_receive(:payments)
      controller.send(:load_payments_and_averages)
    end

    [:day, :week, :month].each do |unit|
      it "should calculate average for #{unit}s" do
        @payments.should_receive(:calculate_average_for).with(unit)
        controller.send(:load_payments_and_averages)
      end
    end
  end
end
