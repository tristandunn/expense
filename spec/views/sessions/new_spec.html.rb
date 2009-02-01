require File.dirname(__FILE__) + '/../../spec_helper'

describe 'when rendering /sessions/new.html' do
  before do
    render 'sessions/new.html.erb'
  end

  it 'should render new session form' do
    response.should have_tag('form[action=?][method=?]', session_path, 'post') do
      with_tag 'label[for=?]',  'email'
      with_tag 'input[name=?]', 'email'

      with_tag 'label[for=?]',  'password'
      with_tag 'input[name=?]', 'password'

      with_tag 'button[type=?]', 'submit'
    end
  end
end