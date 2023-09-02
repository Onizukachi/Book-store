ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module SignInHelper
  def login_as(user)
    if respond_to? :visit
      visit login_url
      fill_in :name, with: user.name
      fill_in :password, with: "Secret149#13"
      click_on 'Login'
      assert_current_path admin_url
    else
      post login_url, params: { name: user.name, password: 'Secret149#13' }
    end
  end

  def logout
    delete logout_url
  end

  def setup
    login_as users(:one)
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end

class ActionDispatch::SystemTestCase
  include SignInHelper
end


