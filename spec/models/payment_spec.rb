require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Payment do
  describe 'class' do
    describe 'when grouping by relative date' do
      it 'should return an array of groups' do
        Timecop.freeze(Time.utc(2010, 6, 2, 4, 0, 0)) do
          @payment = Factory(:payment)
          @user    = @payment.user
          @user.payments.grouped_by_relative_date.to_a.should == [['Today', [@payment]]]
        end
      end
    end

    describe 'when searching' do
      before do
        @payment = Factory(:payment, :item => 'groceries')
      end

      it 'should find payments by item and group by relative date' do
        %w(cer grocer groceries).each do |query|
          results = Payment.search(query)
          results.should == [@payment]
        end
      end
    end
  end

  describe 'when being created' do
    it 'should create valid payment' do
      Factory(:payment).should be_valid
    end

    it 'should require user ID' do
      Factory.build(:payment, :user_id => nil).should_not be_valid
    end

    it 'should require cost' do
      Factory.build(:payment, :cost => nil).should_not be_valid
    end

    it 'should require cost to be greater than zero' do
      Factory.build(:payment, :cost => 0).should_not be_valid
      Factory.build(:payment, :cost => -1).should_not be_valid
    end

    it 'should require item' do
      Factory.build(:payment, :item => nil).should_not be_valid
    end

    it 'should allow a cost with a dollar sign' do
      payment = Factory(:payment, :cost => nil, :item => '$5.45 for lunch')
      payment.cost.should == 5.45
    end

    it 'should allow a cost less than a dollar' do
      payment = Factory(:payment, :cost => nil, :item => '.25 for gum')
      payment.cost.should == 0.25
    end

    describe 'with no cost' do
      ['', 'on', 'for'].each do |separator|
        describe "and cost and item separated by '#{separator}" do
          before do
            @payment = Factory(:payment, :cost => nil,
                                         :item => "5.45 #{separator} lunch")
          end

          it 'should extract cost from item' do
            @payment.cost.should == 5.45
          end

          it 'should remove cost from item' do
            @payment.item.should == 'lunch'
          end
        end
      end
    end
  end

  describe 'instance' do
    before do
      @payment = Factory(:payment)
    end

    it 'should belong to a user' do
      @payment.user.should be_a(User)
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
          Timecop.freeze(Time.utc(2010, 6, 2, 4, 0, 0)) do
            payment = Factory(:payment, :created_at => number_of.days.ago)
            payment.relative_date.should == group
          end
        end
      end
    end
  end
end
