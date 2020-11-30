ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/rails"
require "minitest/reporters"  # for Colorized output
#  For colorful output!
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors) # causes out of order output.

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def setup
    # Once you have enabled test mode, all requests
    # to OmniAuth will be short circuited to use the mock authentication hash.
    # A request to /auth/provider will redirect immediately to /auth/provider/callback.
    OmniAuth.config.test_mode = true
  end

  def mock_auth_hash(user)
    auth_hash = {
        provider: user.provider,
        uid: user.uid,
        info: {
            email: user.email,
            image: user.avatar
        }
    }
    if user.provider == "github"
      auth_hash[:info][:nickname] = user.username
    elsif user.provider == "google_oauth2"
      auth_hash[:info][:name] = user.username
    end
    return auth_hash
  end

  def perform_login(user = nil)
    user ||= User.first

    OmniAuth.config.mock_auth[user.provider.to_sym] = OmniAuth::AuthHash.new(mock_auth_hash(user))
    get auth_callback_path(user.provider.to_sym)

    return user
  end

  # Add more helper methods to be used by all tests here...
end
