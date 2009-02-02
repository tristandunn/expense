require File.dirname(__FILE__) + '/../../spec_helper'

describe 'when rendering /expenses/index.html' do
  before do
    @today     = mock_model(Expense, :cost => 1,  :item => 'a lottery ticket')
    @yesterday = mock_model(Expense, :cost => 10, :item => 'a big bag of chips')

    assigns[:expenses] = [
      ['Today',     [@today]],
      ['Yesterday', [@yesterday]]
    ]

    render 'expenses/index.html.erb'
  end

  it' should render expenses in groups' do
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