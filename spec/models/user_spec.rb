require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  fixtures :users

  describe 'class' do
    describe 'when authenticating a user' do
      before do
        @user = Factory(:user)
      end

      it 'should return the user for valid credentials' do
        User.authenticate(@user.email, 'test').should == @user
      end

      it 'should ignore case of e-mail address' do
        User.authenticate(@user.email.upcase, 'test').should == @user
      end

      it 'should return nil for invalid credentials' do
        User.authenticate(@user.email, 'nope').should be_nil
      end
    end

    describe 'when hashing a password' do
      it 'should not do a single hash' do
        User.hash_password('test').should_not == User.hash_string('test')
      end
    end

    describe 'when hashing a string' do
      it 'should should use SHA-512' do
        User.hash_string('test').size.should ==128
      end

      it 'should hash string with a salt' do
        User.hash_string('test').should_not == Digest::SHA512.hexdigest('test')
      end
    end
  end

  describe 'when being created' do
    it 'should require e-mail' do
      Factory.build(:user, :email => nil).should_not be_valid
    end

    it 'should require valid e-mail' do
      Factory.build(:user, :email => '@.com').should_not be_valid
    end

    it 'should require unique e-mail' do
      user = Factory(:user)

      Factory.build(:user, :email => user.email.upcase).should_not be_valid
    end

    it 'should require password' do
      Factory.build(:user, :password => nil).should_not be_valid
    end

    it 'should require password confirmation' do
      Factory.build(:user, :password_confirmation => nil).should_not be_valid
    end

    it 'should require password to match confirmation' do
      Factory.build(:user, :password => 'nope').should_not be_valid
    end

    it 'should generate and set hashed password' do
      Factory(:user).hashed_password.should_not be_nil
    end

    it 'should downcase e-mail' do
      Factory(:user, :email => 'SoMe@GuY.com').email.should == 'some@guy.com'
    end
  end

  describe 'instance' do
    it 'should have many payments' do
      Factory(:user).payments.should == []
    end
  end

  describe 'when being updated' do
    before do
      @user = Factory(:user)
    end

    it 'should re-hash password, if it was modified' do
      @user.update_attributes(:password => 'secure', :password_confirmation => 'secure')

      User.authenticate(@user.email, 'secure').should == @user
    end

    it 'should not re-hash password, if it was not modified' do
      @user.update_attributes(:email => 'new-address@example.com')

      User.authenticate(@user.email, 'test').should == @user
    end
  end

  describe 'when being destroyed' do
    before do
      @user    = Factory(:user)
      @payment = Factory(:payment, :user => @user)
    end

    it 'should destroy associated payments' do
      lambda {
        @user.destroy
      }.should change(Payment, :count).by(-1)
    end
  end
end
