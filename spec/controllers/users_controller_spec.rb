require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  describe 'on GET to new' do
    before do
      @user = mock_model(User)

      User.stub!(:new).and_return(@user)
    end

    it 'should create new user' do
      User.should_receive(:new).with().and_return(@user)
      do_get
    end

    it 'should assign user' do
      do_get
      assigns[:user].should == @user
    end

    it 'render "users/new" template' do
      do_get
      response.should render_template('users/new')
    end

    protected

    def do_get
      get :new
    end
  end

  describe 'on POST to create' do
    before do
      @user = mock_model(User)
      @user.stub!(:save)

      User.stub!(:new).and_return(@user)

      controller.stub!(:current_user=)
    end

    it 'should create new user' do
      User.should_receive(:new).with(hash_including(valid_attributes)).and_return(@user)
      do_post
    end

    it 'should assign user' do
      do_post
      assigns[:user].should == @user
    end

    it 'should attempt to save user' do
      @user.should_receive(:save)
      do_post
    end

    describe 'when saved successfully' do
      before do
        @user.stub!(:save).and_return(true)
      end

      it 'should set current user' do
        controller.should_receive(:current_user=).with(@user)
        do_post
      end

      it 'should redirect' do
        do_post
        response.should redirect_to(root_url)
      end
    end

    describe 'when not saved successfully' do
      before do
        @user.stub!(:save).and_return(false)
      end

      it 'should not set current user' do
        controller.should_not_receive(:current_user=)
        do_post
      end

      it 'should render "users/new" template' do
        do_post
        response.should render_template('users/new')
      end
    end

    protected

    def do_post
      post :create,
           :user => valid_attributes
    end

    def valid_attributes
      { :email                 => 'default-valid@example.com',
        :password              => 'test',
        :password_confirmation => 'test' }
    end
  end

  describe 'on GET to delete' do
    before do
      user_is_valid
    end

    describe 'when requested for current user' do
      it 'should render "users/delete" template' do
        do_get
        response.should render_template('users/delete')
      end
    end

    describe 'when not requested for current user' do
      it 'should redirect' do
        do_get :id => -1
        response.should redirect_to(root_url)
      end
    end

    protected

    def do_get(options = {})
      get :delete,
          :id => options[:id] || @user.id
    end
  end

  describe 'on DELETE to destroy' do
    before do
      user_is_valid

      @user.stub!(:destroy)
    end

    it 'should redirect' do
      do_delete
      response.should redirect_to(root_url)
    end

    describe 'when requested for correct user' do
      it 'should destroy user' do
        @user.should_receive(:destroy)
        do_delete
      end
    end

    describe 'when not requested for correct user' do
      it 'should not destroy user' do
        @user.should_not_receive(:destroy)
        do_delete :id => -1
      end
    end

    protected

    def do_delete(options = {})
      delete :destroy,
             :id => options[:id] || @user.id
    end
  end
end
