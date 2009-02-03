require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExpensesHelper do
  describe 'when determing the class name for an average' do
    before do
      @expenses = mock('Expenses')
    end

    describe 'and the average is above normal' do
      before do
        @expenses.stub!(:is_above_average_for?).and_return(true)
      end

      it 'should return above' do
        helper.class_for_status_of(:day, @expenses).should == 'above'
      end
    end

    describe 'and the average is below normal' do
      before do
        @expenses.stub!(:is_above_average_for?).and_return(false)
      end

      it 'should return below' do
        helper.class_for_status_of(:day, @expenses).should == 'below'
      end
    end
  end
end