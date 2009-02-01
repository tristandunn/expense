require File.dirname(__FILE__) + '/../../spec_helper'

describe 'when rendering /users/new.html' do
  describe 'with no errors' do
    before do
      assigns[:user] = mock_model(User, :new_record? => true, :email => nil, :password => nil, :password_confirmation => nil)

      render 'users/new.html.erb'
    end

    it 'should render new user form' do
      response.should have_tag('form[action=?][method=?]', users_path, 'post') do
        with_tag 'label[for=?]',  'user_email'
        with_tag 'input[name=?]', 'user[email]'

        with_tag 'label[for=?]',  'user_password'
        with_tag 'input[name=?]', 'user[password]'

        with_tag 'label[for=?]',  'user_password_confirmation'
        with_tag 'input[name=?]', 'user[password]'

        with_tag 'button[type=?]', 'submit'
      end
    end
  end

  describe 'with errors' do
    before do
      @errors = ActiveRecord::Errors.new(User.new)
      @errors.add_on_blank([:email, :password, :password_confirmation])

      assigns[:user] = mock_model(User, :new_record? => true, :email => nil, :password => nil, :password_confirmation => nil)
      assigns[:user].stub!(:errors).and_return(@errors)

      render 'users/new.html.erb'
    end

    it 'should render error messages' do
      response.should have_tag('div#errors') do
        with_tag 'p'

        with_tag('ul') do
          with_tag 'li:nth-child(1)'
          with_tag 'li:nth-child(2)'
          with_tag 'li:nth-child(3)'
        end
      end
    end

    it 'should render new user form, with wrapper on elements with errors' do
      response.should have_tag('form[action=?][method=?]', users_path, 'post') do
        with_tag 'label[for=?]', 'user_email'
        with_tag('div[class=?]', 'fieldWithErrors') do
          with_tag 'input[name=?]', 'user[email]'
        end

        with_tag 'label[for=?]', 'user_password'
        with_tag('div[class=?]', 'fieldWithErrors') do
          with_tag 'input[name=?]', 'user[password]'
        end

        with_tag 'label[for=?]', 'user_password_confirmation'
        with_tag('div[class=?]', 'fieldWithErrors') do
          with_tag 'input[name=?]', 'user[password]'
        end

        with_tag 'button[type=?]', 'submit'
      end
    end
  end
end