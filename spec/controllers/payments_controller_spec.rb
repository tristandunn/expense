require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PaymentsController do
  before do
    user_is_valid

    @payment  = mock('Payment')
    @payments = mock('Payments')
    @payments.stub!(:build).and_return(@payment)
    @payments.stub!(:calculate_average_for)

    @user.stub!(:payments).and_return(@payments)
  end

  describe 'on GET to index' do
    before do
      @groups = mock('Groups')
      @payments.stub!(:find_recent_grouped_by_relative_date).
                and_return(@groups)

      get :index
    end

    it { should assign_to(:groups, @groups) }
    it { should assign_to(:payment, @payment) }
    it { should assign_to(:payments, @payments) }
    it { should render_template(:index) }
  end

  describe 'on GET to new' do
    before do
      get :new
    end

    it { should assign_to(:payment, @payment) }
    it { should render_template(:new) }
  end

  describe 'on POST to create' do
    describe 'with valid attributes' do
      before do
        attributes = Factory.attributes_for(:payment)

        @payment.stub!(:save).and_return(true)
        @payments.should_receive(:build).
                  with(hash_including(attributes)).
                  and_return(@payment)

        post :create, :payment => attributes
      end

      it { should redirect_to(root_url) }
    end

    describe 'with invalid attributes' do
      before do
        @payment.stub!(:save).and_return(false)
        @payments.should_receive(:build).with({}).and_return(@payment)

        post :create, :payment => {}
      end

      it { should assign_to(:payment, @payment) }
      it { should render_template(:new) }
    end
  end

  describe 'on GET to search' do
    before do
      @groups = mock('Groups')

      Payment.stub!(:search_grouped_by_relative_date).and_return(@groups)

      get :search, :search => { :query => 'test' }
    end

    it { should assign_to(:query, 'test') }
    it { should assign_to(:groups, @groups) }
    it { should assign_to(:payment, @payment) }
    it { should assign_to(:payments, @payments) }
    it { should render_template(:search) }
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
