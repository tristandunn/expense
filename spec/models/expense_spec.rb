require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Expense do
  describe 'when being created' do
    it 'should create valid expense' do
      lambda {
        create_expense
      }.should change(Expense, :count).by(1)
    end

    it 'should require user ID' do
      create_expense(:user_id => nil).errors.on(:user_id).should_not be_nil
    end

    it 'should require cost' do
      create_expense(:cost => nil).errors.on(:cost).should_not be_nil
    end

    it 'should require cost to be greater than zero' do
      create_expense(:cost =>  0).errors.on(:cost).should_not be_nil
      create_expense(:cost => -1).errors.on(:cost).should_not be_nil
    end

    it 'should require item' do
      create_expense(:item => nil).errors.on(:item).should_not be_nil
    end
  end

  describe 'instance' do
    fixtures :expenses, :users

    before do
      @expense = expenses(:default)
    end

    it 'should belong to a user' do
      @expense.user.should == users(:default)
    end
  end

  protected

  def create_expense(options = {})
    returning(new_expense(options)) do |account|
      account.save
    end
  end

  def new_expense(options = {})
    Expense.new(valid_attributes.merge(options))
  end

  def valid_attributes
    { :user_id => 1,
      :cost    => 695.00,
      :item    => 'registration for RailsConf 2009.'
    }
  end
end