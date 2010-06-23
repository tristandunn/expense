require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PaymentsHelper do
  describe 'when determing the class name for an average' do
    before do
      @payments = mock('Payments')
    end

    describe 'and the average is above normal' do
      before do
        @payments.stub!(:is_above_average_for?).and_return(true)
      end

      it 'should return above' do
        helper.class_for_status_of(:day, @payments).should == 'above'
      end
    end

    describe 'and the average is below normal' do
      before do
        @payments.stub!(:is_above_average_for?).and_return(false)
      end

      it 'should return below' do
        helper.class_for_status_of(:day, @payments).should == 'below'
      end
    end
  end
end
