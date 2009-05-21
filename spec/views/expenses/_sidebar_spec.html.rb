require File.dirname(__FILE__) + '/../../spec_helper'

describe 'when rendering /expenses/_sidebar.html' do
  before do
    assigns[:averages] = {}

    template.stub!(:class_for_status_of)
  end

  it 'should render search form in sidebar' do
    render 'expenses/_sidebar.html.erb'

    response.should have_tag('form[action=?][method=?]', search_expenses_path, 'get') do
      with_tag 'input[name=?]', 'search[query]'
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
      render 'expenses/_sidebar.html.erb'

      response.should have_tag('dd[class=?]', 'below', '$1.00')
      response.should have_tag('dd[class=?]', 'below', '$2.00')
      response.should have_tag('dd[class=?]', 'below', '$3.00')
    end
  end

  describe 'when no averagaes are present' do
    it 'should render $0.00 for each' do
      render 'expenses/_sidebar.html.erb'

      response.should have_tag('dl') do |elements|
        with_tag 'dd', '$0.00', :count => 3
      end
    end
  end
end