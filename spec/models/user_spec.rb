require "spec_helper"

describe User do
  describe "when being created" do
    it "should require e-mail" do
      build(:user, email: nil).should_not be_valid
    end

    it "should require valid e-mail" do
      build(:user, email: "@.com").should_not be_valid
    end

    it "should require unique e-mail" do
      user = create(:user)

      build(:user, email: user.email.upcase).should_not be_valid
    end

    it "should require password" do
      build(:user, password: nil).should_not be_valid
    end

    it "should require password confirmation" do
      build(:user, password_confirmation: nil).should_not be_valid
    end

    it "should require password to match confirmation" do
      build(:user, password: "nope").should_not be_valid
    end

    it "should downcase e-mail" do
      create(:user, email: "SoMe@GuY.com").email.should == "some@guy.com"
    end
  end

  describe "instance" do
    it "should have many payments" do
      create(:user).payments.should == []
    end
  end

  describe "when being destroyed" do
    before do
      @user    = create(:user)
      @payment = create(:payment, user: @user)
    end

    it "should destroy associated payments" do
      lambda {
        @user.destroy
      }.should change(Payment, :count).by(-1)
    end
  end
end
