require "test_helper"

class AfterLogoutTest < ActionDispatch::IntegrationTest
  test "cant interact with sensitive data after logout" do
    # delete "/logout"
    # assert_select "div", "Logged out"
  end
end
