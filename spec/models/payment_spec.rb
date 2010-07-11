require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Payment do
  describe 'class' do
    describe 'when calculating the average for a given unit' do
      before do
        Payment.stub!(:find_averages_for).and_return([5, 10])
        Payment.stub!(:determine_duration_since_first_entry_in).and_return(2)
      end

      it 'should return the average' do
        Payment.calculate_average_for(:day).should == 7.5
      end
    end

    describe 'when determing if the current average is above the overall average' do
      describe 'with records' do
        before do
          Payment.stub!(:exists?).and_return(true)
          Payment.stub!(:find_averages_for).and_return([4, 8])
          Payment.stub!(:calculate_average_for).and_return(2)
        end

        it 'should find the averages for the provided unit' do
          Payment.should_receive(:find_averages_for).with(:day)
          Payment.is_above_average_for?(:day)
        end

        it 'should calculate the averages for the provided unit' do
          Payment.should_receive(:calculate_average_for).with(:day)
          Payment.is_above_average_for?(:day)
        end

        describe 'when the current average is greater than the overall' do
          it 'should return true' do
            Payment.is_above_average_for?(:week).should be_true
          end
        end

        describe 'when the current average is less than the overall' do
          before do
            Payment.stub!(:find_averages_for).and_return([2, 4])
            Payment.stub!(:calculate_average_for).and_return(4)
          end

          it 'should return false' do
            Payment.is_above_average_for?(:week).should be_false
          end
        end
      end

      describe 'without records' do
        before do
          Payment.stub!(:exists?)
        end

        it 'should return false' do
          Payment.is_above_average_for?(:month).should be_false
        end
      end
    end

    describe 'when finding recent payments grouped by relative date' do
      before do
        @payment = Factory(:payment)
        @user    = @payment.user
      end

      it 'should return an array of groups' do
        @user.payments.find_recent_grouped_by_relative_date.to_a.should == [['Today', [@payment]]]
      end

      it 'should support a custom limit' do
        @user.payments.find_recent_grouped_by_relative_date(0).to_a.should == []
      end
    end

    describe 'when finding averages by range' do
      before do
        Timecop.travel(Time.local(2010, 6, 2, 12, 0, 0))

        today_1     = Factory(:payment, :cost => 5)
        today_2     = Factory(:payment, :cost => 10)
        last_week_1 = Factory(:payment, :cost => 40, :created_at => 8.days.ago)
        last_week_2 = Factory(:payment, :cost => 60, :created_at => 9.days.ago)
        last_month  = Factory(:payment, :cost => 25, :created_at => 30.days.ago)
      end

      after do
        Timecop.return
      end

      describe 'of days' do
        it 'should return averages for each day' do
          Payment.find_averages_for(:day).should == [7.50, 40.00, 60.00, 25.00]
        end
      end

      describe 'of weeks' do
        it 'should return averages for each week' do
          Payment.find_averages_for(:week).should == [7.50, 50.00, 25.00]
        end
      end

      describe 'of months' do
        it 'should return averages for each month' do
          Payment.find_averages_for(:month).should == [7.50, 41.67]
        end
      end
    end

    describe 'when determing the duration since the first entry' do
      describe 'with no entries' do
        before do
          Payment.stub!(:first).and_return(nil)
        end

        it 'should return one' do
          Payment.determine_duration_since_first_entry_in(nil).should == 1
        end
      end

      describe 'with at least one entry' do
        before do
          Factory(:payment, :created_at => 60.days.ago)
        end

        describe 'in days' do
          it 'should return number of days since first entry' do
            Payment.determine_duration_since_first_entry_in(:day).round.should == 60
          end
        end

        describe 'in weeks' do
          it 'should return number of weeks since first entry' do
            Payment.determine_duration_since_first_entry_in(:week).round.should == 9
          end
        end

        describe 'in months' do
          it 'should return number of months since first entry' do
            Payment.determine_duration_since_first_entry_in(:month).round.should == 2
          end
        end
      end
    end

    describe 'when determing the format for a range' do
      { :day => '%j%Y', :week => '%W%Y', :month => '%m%Y' }.each do |range, format|
        it "should return '#{format}' for #{range}" do
          Payment.determine_format_for(range).should == format
        end
      end
    end

    describe 'when searching' do
      before do
        @payment = Factory(:payment, :item => 'groceries')
      end

      it 'should find payments by item and group by relative date' do
        %w(cer grocer groceries).each do |query|
          results = Payment.search_grouped_by_relative_date(query).to_a
          results.should == [['Today', [@payment]]]
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
          payment = Factory(:payment, :created_at => number_of.days.ago)
          payment.relative_date.should == group
        end
      end
    end
  end
end
