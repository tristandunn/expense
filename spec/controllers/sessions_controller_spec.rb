require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  describe 'on GET to new' do
    before do
      get :new
    end

    it { should render_template(:new) }
  end

  describe 'on POST to create' do
    describe 'with valid authentication' do
      before do
        @user = mock_model(User)

        User.stub!(:authenticate).
             with('valid@example.com', 'test').
             and_return(@user)

        post :create, :email => 'valid@example.com', :password => 'test'
      end

      it 'should set current user to authenticated user' do
        controller.__send__(:current_user).should == @user
      end

      it { should redirect_to(root_url) }
    end

    describe 'with invalid credentials' do
      before do
        User.stub!(:authenticate).
             with('invalid@example.com', 'test').
             and_return(nil)

        post :create, :email => 'invalid@example.com', :password => 'test'
      end

      it 'should set current user to nil' do
        controller.__send__(:current_user).should_not be_a(User)
      end

      it { should render_template(:new) }
    end
  end

  describe 'on DELETE to destroy' do
    before do
      session[:id] = 1

      delete :destroy, :id => 1
    end

    it 'should reset session' do
      session[:id].should be_nil
    end

    it { should redirect_to(root_url) }
  end
end
