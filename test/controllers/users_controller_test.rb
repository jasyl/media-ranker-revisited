require "test_helper"

describe UsersController do
  # Tests written for Oauth.
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root path" do
      user = users(:dan)
      expect {
        perform_login(user)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      expect(flash[:result_text]).must_equal "Logged in as returning user #{user.username}"
    end

    it "creates an account for a new user and redirects to the root route" do
      user = User.new(provider: "github", uid: 99999, username: "test_user", email: "test@user.com")

      expect {
        perform_login(user)
      }.must_differ "User.count", 1

      must_redirect_to root_path
      expect(session[:user_id]).must_equal(User.find_by(provider: user.provider,
        uid: user.uid, email: user.email).id)
        expect(flash[:result_text]).must_equal "Logged in as new user #{user.username}"
    end

    it "will handle a request with invalid information" do
      user = User.new(provider: "github", uid: nil, username: nil, email: nil)
      expect {
        perform_login(user)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(flash[:result_text]).must_equal "Could not create new user account. Username can't be blank"
      expect(session[:user_id]).must_be_nil
    end

    it "will handle a request with no auth hash" do

      OmniAuth.config.mock_auth[:github] = nil
      expect {
        get auth_callback_path(:github)
      }.wont_differ "User.count", 0

      expect(flash[:result_text]).must_equal "Could not create new user account. Username can't be blank"
      expect(session[:user_id]).must_be_nil

    end

    it "will handle a request with and invalid auth provider" do
      user = User.new(provider: "github", uid: 99999, username: "test_user", email: "test@user.com")

      OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      get auth_callback_path(:google)
    end
  end

  describe "logout" do
    it "will log out a logged in user" do
      user = users(:dan)
      perform_login(user)

      post logout_path

      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil
      expect(flash[:result_text]).must_equal "Successfully logged out"
    end

    it "will redirect back and give a flash notice if a guest user tries to logout" do
      post logout_path

      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil
      expect(flash[:result_text]).must_equal "You were not logged in!"
    end
  end
end
