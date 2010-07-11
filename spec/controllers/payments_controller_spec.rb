require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PaymentsController do
  before do
    user_is_valid

    @payment  = mock('Payment')
    @payments = mock('Payments')
    @payments.stub!(:build).and_return(@payment)

    @user.stub!(:payments).and_return(@payments)
  end

  describe 'on GET to index' do
    before do
      @groups   = mock('Groups')
      @averages = mock('Averages')

      @payments.stub!(:find_recent_grouped_by_relative_date).
                and_return(@groups)
      @payments.stub!(:calculate_averages_over_time).
                and_return(@averages)

      get :index
    end

    it { should assign_to(:groups, @groups) }
    it { should assign_to(:payment, @payment) }
    it { should assign_to(:payments, @payments) }
    it { should assign_to(:averages, @averages) }
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

      it { should redirect_to(root_url) }
    end
  end
end
