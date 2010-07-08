require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  describe 'on GET to new' do
    before do
      @user = mock_model(User)

      User.stub!(:new).and_return(@user)

      get :new
    end

    it { should assign_to(:user, @user) }
    it { should render_template(:new) }
  end

  describe 'on POST to create' do
    before do
      @user = mock_model(User)
      @user.stub!(:save)

      User.stub!(:new).and_return(@user)
    end

    describe 'when saved successfully' do
      before do
        @user.stub!(:save).and_return(true)

        attributes = Factory.attributes_for(:user)

        User.should_receive(:new).
             with(hash_including(attributes)).
             and_return(@user)

        post :create, :user => attributes
      end

      it 'should set current user' do
        controller.__send__(:current_user).should == @user
      end

      it { should assign_to(:user, @user) }
      it { should redirect_to(root_url) }
    end

    describe 'when not saved successfully' do
      before do
        @user.stub!(:save).and_return(false)

        User.should_receive(:new).with({}).and_return(@user)

        post :create, :user => {}
      end

      it 'should not set current user' do
        controller.__send__(:current_user).should_not be_a(User)
      end

      it { should assign_to(:user, @user) }
      it { should render_template(:new) }
    end
  end

  describe 'on GET to delete' do
    before do
      user_is_valid
    end

    describe 'when requested for current user' do
      before do
        get :delete, :id => @user.id
      end

      it { should render_template(:delete) }
    end

    describe 'when not requested for current user' do
      before do
        get :delete, :id => -1
      end

      it { should redirect_to(root_url) }
    end
  end

  describe 'on DELETE to destroy' do
    before do
      user_is_valid
    end

    describe 'when requested for correct user' do
      before do
        @user.should_receive(:destroy)

        delete :destroy, :id => @user.id
      end

      it { should redirect_to(root_url) }
    end

    describe 'when not requested for correct user' do
      before do
        @user.should_not_receive(:destroy)

        delete :destroy, :id => -1
      end

      it { should redirect_to(root_url) }
    end
  end
end
