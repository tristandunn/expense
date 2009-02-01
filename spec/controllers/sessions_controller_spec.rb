require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  describe 'on GET to new' do
    it 'should render "sessions/new" template' do
      do_get
      response.should render_template('sessions/new')
    end

    protected

    def do_get
      get :new
    end
  end

  describe 'on POST to create' do
    before do
      controller.stub!(:logged_in?)
      controller.stub!(:current_user=)
    end

    it 'should attempt to authenticate user' do
      User.should_receive(:authenticate).with('valid@example.com', 'test')
      do_post
    end

    describe 'with valid authentication' do
      before do
        @user = mock_model(User)

        User.stub!(:authenticate).and_return(@user)

        controller.stub!(:logged_in?).and_return(true)
      end

      it 'should set current user to authenticated user' do
        controller.should_receive(:current_user=).with(@user)
        do_post
      end

      it 'should redirect' do
        do_post
        response.should redirect_to('/')
      end
    end

    describe 'with invalid credentials' do
      before do
        User.stub!(:autenticate).and_return(nil)

        controller.stub!(:logged_in?).and_return(false)
      end

      it 'should set current user to nil' do
        controller.should_receive(:current_user=).with(nil)
        do_post
      end

      it 'should render "sessions/new" template' do
        do_post
        response.should render_template('sessions/new')
      end
    end

    protected

    def do_post
      post :create,
           :email    => 'valid@example.com',
           :password => 'test'
    end
  end

  describe 'on DELETE to destroy' do
    before do
      controller.stub!(:reset_session)
    end

    it 'should reset session' do
      controller.should_receive(:reset_session)
      do_delete
    end

    it 'should redirect' do
      do_delete
      response.should redirect_to('/')
    end

    protected

    def do_delete
      delete :destroy,
             :id => 1
    end
  end
end