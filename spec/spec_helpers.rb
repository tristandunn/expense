Rspec.configure do |config|
  def user_is_valid
    controller.stub!(:current_user).and_return(@user = mock_model(User))
  end
end
