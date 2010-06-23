require File.dirname(__FILE__) + '/../../spec_helper'

describe 'when rendering /payments/index.html' do
  before do
    @today     = mock_model(Payment, :cost => 1,  :item => 'a lottery ticket')
    @yesterday = mock_model(Payment, :cost => 10, :item => 'a big bag of chips')

    assigns[:groups]   = [
      ['Today',     [@today]],
      ['Yesterday', [@yesterday]]
    ]

    template.should_receive(:render).with(:partial => 'sidebar')
  end

  it' should render payments in groups' do
    render 'payments/index.html.erb'

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
