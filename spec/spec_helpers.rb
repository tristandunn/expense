Spec::Runner.configure do |config|
  # Create a mock User and stub it as the currently active user.
  def user_is_valid
    controller.stub!(:current_user).and_return(@user = mock_model(User))
  end
end