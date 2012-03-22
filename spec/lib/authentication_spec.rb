require "spec_helper"

class Example
  include Authentication
end

describe Authentication do
  describe "class" do
    describe "when included" do
      before do
        @base = mock("Base", send: true, helper_method: true)
      end

      it "should add helper methods to base" do
        @base.should_receive(:send).with(:helper_method, :current_user, :signed_in?)
        Authentication.included(@base)
      end
    end
  end

  describe "instance" do
    before do
      @class = Example.new
    end

    describe "#access_denied" do
      before do
        @class.stub!(:redirect_to)
        @class.stub!(:new_session_url).and_return("/")
      end

      it "should redirect to new_session_url" do
        @class.should_receive(:redirect_to).with("/")
        @class.send(:access_denied)
      end
    end

    describe "#user_from_session" do
      before do
        @user    = mock_model(User)
        @session = {}

        @class.stub!(:session).and_return(@session)
        @class.stub!(:current_user=)

        User.stub!(:find).and_return(@user)
      end

      describe "when user is defined in the session" do
        before do
          @session[:user] = 1
        end

        it "should attempt to find user" do
          User.should_receive(:find).with(@session[:user]).and_return(@user)
          @class.send(:user_from_session)
        end

        it "should assign user to current_user" do
          @class.should_receive(:current_user=).with(@user)
          @class.send(:user_from_session)
        end
      end

      describe "when user is not defined in the session" do
        it "should not attempt to find user" do
          User.should_not_receive(:find)
          @class.send(:user_from_session)
        end

        it "should not assign current_user" do
          @class.should_not_receive(:current_user=)
          @class.send(:user_from_session)
        end
      end
    end

    describe "#current_user" do
      before do
        @class.stub!(:user_from_session)
      end

      describe "when a user is already loaded" do
        before do
          @class.instance_variable_set("@current_user", true)
        end

        it "should not attempt to load user from session" do
          @class.should_not_receive(:user_from_session)
          @class.send(:current_user)
        end
      end

      describe "when no user is loaded" do
        it "should attempt to load user from session" do
          @class.should_receive(:user_from_session)
          @class.send(:current_user)
        end

        describe "and a user is found" do
          before do
            @user = mock_model(User)

            @class.stub!(:user_from_session).and_return(@user)
          end

          it "should assign user to instance variable" do
            @class.send(:current_user)
            @class.instance_variable_get("@current_user").should == @user
          end
        end

        describe "and no user is found" do
          before do
            @class.stub!(:user_from_session).and_return(nil)
          end

          it "should assign :false to instance variable" do
            @class.send(:current_user)
            @class.instance_variable_get("@current_user").should == :false
          end
        end
      end
    end

    describe "#current_user=" do
      before do
        @user    = mock_model(User)
        @session = {}

        @class.stub!(:session).and_return(@session)
      end

      describe "when assigned a user" do
        before do
          @class.send(:current_user=, @user)
        end

        it "should assign user ID to session" do
          @class.session[:user].should == @user.id
        end

        it "should assign user to instance variable" do
          @class.instance_variable_get("@current_user").should == @user
        end
      end

      describe "when assigned anything besides a user" do
        before do
          @class.send(:current_user=, false)
        end

        it "should assign nil to session" do
          @class.session[:user].should be_nil
        end

        it "should assign nil to instance variable" do
          @class.instance_variable_get("@current_user").should be_nil
        end
      end
    end

    describe "#signed_in?" do
      before do
        @class.stub!(:current_user)
      end

      describe "when a user is present" do
        before do
          @class.stub!(:current_user).and_return(true)
        end

        it "should return true" do
          @class.send(:signed_in?).should be_true
        end
      end

      describe "when no user is present" do
        before do
          @class.stub!(:current_user).and_return(:false)
        end

        it "should return false" do
          @class.send(:signed_in?).should be_false
        end
      end
    end

    describe "#authenticate" do
      before do
        @class.stub!(:signed_in?)
        @class.stub!(:access_denied)
      end

      describe "when signed in" do
        before do
          @class.stub!(:signed_in?).and_return(true)
        end

        it "should not call access_denied" do
          @class.should_not_receive(:access_denied)
          @class.send(:authenticate)
        end
      end

      describe "when not signed in" do
        before do
          @class.stub!(:signed_in?).and_return(false)
        end

        it "should call access_denied" do
          @class.should_receive(:access_denied)
          @class.send(:authenticate)
        end
      end
    end
  end
end
