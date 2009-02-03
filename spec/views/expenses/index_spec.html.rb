require File.dirname(__FILE__) + '/../../spec_helper'

describe 'when rendering /expenses/index.html' do
  before do
    @today     = mock_model(Expense, :cost => 1,  :item => 'a lottery ticket')
    @yesterday = mock_model(Expense, :cost => 10, :item => 'a big bag of chips')

    assigns[:averages] = {}
    assigns[:groups]   = [
      ['Today',     [@today]],
      ['Yesterday', [@yesterday]]
    ]

    template.stub!(:class_for_status_of)
  end

  it' should render expenses in groups' do
    render 'expenses/index.html.erb'

    response.should have_tag('h3', 'Today')
    response.should have_tag('li') do
      with_tag 'strong', '$1.00'
      with_tag 'span',   'a lottery ticket'
    end

    response.should have_tag('h3', 'Yesterday')
    response.should have_tag('li') do
      with_tag 'strong', '$10.00'
      with_tag 'span',   'a big bag of chips'
    end
  end

  describe 'when averages are present' do
    before do
      assigns[:averages] = {
        :day   => 1,
        :week  => 2,
        :month => 3
      }

      template.stub!(:class_for_status_of).and_return('below')
    end

    it 'should render averages for day, week and month with class name of status' do
      render 'expenses/index.html.erb'

      response.should have_tag('dd[class=?]', 'below', '$1.00')
      response.should have_tag('dd[class=?]', 'below', '$2.00')
      response.should have_tag('dd[class=?]', 'below', '$3.00')
    end
  end

  describe 'when no averagaes are present' do
    it 'should render $0.00 for each' do
      render 'expenses/index.html.erb'

      response.should have_tag('dl') do |elements|
        with_tag 'dd', '$0.00', :count => 3
      end
    end
  end
end