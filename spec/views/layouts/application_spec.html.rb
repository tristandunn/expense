require File.dirname(__FILE__) + '/../../spec_helper'

describe 'when rendering /layouts/application.html' do
  describe 'when logged in' do
    before do
      assigns[:expense] = mock_model(Expense, :item => '', :new_record? => true)

      template.stub!(:logged_in?).and_return(true)

      render 'layouts/application.html.erb'
    end

    it 'should render new expense form' do
      response.should have_tag('form[action=?][method=?]', expenses_path, 'post') do
        with_tag 'label[for=?]',  'expense_item'
        with_tag 'input[name=?]', 'expense[item]'

        with_tag 'button[type=?]', 'submit'
      end
    end
  end
end