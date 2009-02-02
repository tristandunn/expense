require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Expense do
  before do
    Time.zone = 'America/Chicago'
  end

  describe 'class' do
    describe 'when finding recent expenses grouped by relative date' do
      fixtures :expenses, :users

      it 'should return an array of groups' do
        users(:default).expenses.find_recent_grouped_by_relative_date.to_a.should == [['Today', [expenses(:default)]]]
      end

      it 'should support a custom limit' do
        users(:default).expenses.find_recent_grouped_by_relative_date(0).to_a.should == []
      end
    end
  end

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

    describe 'with no cost' do
      ['', 'on', 'for'].each do |separator|
        describe "and cost and item separated by '#{separator}" do
          before do
            @expense = create_expense(:cost => nil, :item => "5.45 #{separator} Subway for lunch")
          end

          it 'should extract cost from item' do
            @expense.cost.should == 5.45
          end

          it 'should remove cost from item' do
            @expense.item.should == 'Subway for lunch'
          end
        end
      end
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

    describe 'when determine relative date from today' do
      { 0    => 'Today',
        1    => 'Yesterday',
        2    => 'Last Week',
        7    => 'Two Weeks Ago',
        14   => 'Three Weeks Ago',
        21   => 'Four Weeks Ago',
        30   => 'Last Month',
        60   => 'Two Months Ago',
        90   => 'Three Months Ago',
        120  => 'Four Months Ago',
        140  => 'This Year',
        365  => 'Last Year',
        730  => 'Two Years Ago',
        1095 => 'Several Years Ago'
      }.each do |number_of, group|
        it "should return '#{group}' for #{number_of} days ago" do
          expense = create_expense(:created_at => Time.now.beginning_of_day - number_of.days)
          expense.relative_date.should == group
        end
      end
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