require File.dirname(__FILE__) + '/../../spec_helper'

describe 'when rendering /expenses/search.html' do
  before do
    assigns[:query]  = 'test'

    template.should_receive(:render).with(:partial => 'sidebar')
  end

  describe 'without results' do
    before do
      assigns[:groups] = []
    end

    it 'should render the query in the sub-heading' do
      render 'expenses/search.html.erb'

      response.should have_tag('h3', 'Search for &#8220;test&#8221;')
    end
  end

  describe 'with resullts' do
    before do
      @today     = mock_model(Expense, :cost => 1,  :item => 'a lottery ticket')
      @yesterday = mock_model(Expense, :cost => 10, :item => 'a big bag of chips')

      assigns[:groups] = [
        ['Today',     [@today]],
        ['Yesterday', [@yesterday]]
      ]
    end

    it 'should render the query in the heading' do
      render 'expenses/search.html.erb'

      response.should have_tag('h2', 'Search for &#8220;test&#8221;')
    end

    it' should render results in groups' do
      render 'expenses/search.html.erb'

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
  end
end