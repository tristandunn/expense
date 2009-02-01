require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  fixtures :users

  describe 'class' do
    describe 'when authenticating a user' do
      before do
        @user = users(:default)
      end

      it 'should return the user for valid credentials' do
        User.authenticate(@user.email, 'test').should == @user
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
    it 'should create valid user' do
      lambda {
        create_user
      }.should change(User, :count).by(1)
    end

    it 'should require e-mail' do
      create_user(:email => nil).errors.on(:email).should_not be_nil
    end

    it 'should require valid e-mail' do
      create_user(:email => '@.com').errors.on(:email).should_not be_nil
    end

    it 'should require unique e-mail' do
      create_user(:email => users(:default).email.upcase).errors.on(:email).should_not be_nil
    end

    it 'should require password' do
      create_user(:password => nil).errors.on(:password).should_not be_nil
    end

    it 'should require password confirmation' do
      create_user(:password_confirmation => nil).errors.on(:password_confirmation).should_not be_nil
    end

    it 'should require password to match confirmation' do
      create_user(:password => 'nope').errors.on(:password).should_not be_nil
    end

    it 'should generate and set hashed password' do
      create_user.hashed_password.should_not be_nil
    end

    it 'should downcase e-mail' do
      create_user(:email => 'SoMe@GuY.com').email.should == 'some@guy.com'
    end
  end

  describe 'instance' do
    fixtures :expenses, :users

    it 'should have many expenses' do
      users(:default).expenses.should == [expenses(:default)]
    end
  end

  describe 'when being updated' do
    before do
      @user = users(:default)
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
    fixtures :expenses, :users

    before do
      @user = users(:default)
    end

    it 'should destroy associated expenses' do
      lambda {
        @user.destroy
      }.should change(Expense, :count).by(-1)
    end
  end

  protected

  def create_user(options = {})
    returning(new_user(options)) do |account|
      account.save
    end
  end

  def new_user(options = {})
    User.new(valid_attributes.merge(options))
  end

  def valid_attributes
    { :email                 => 'default-valid@example.com',
      :password              => 'test',
      :password_confirmation => 'test'
    }
  end
end