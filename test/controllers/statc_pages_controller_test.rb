require "test_helper"

class StatcPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get statc_pages_home_url
    assert_response :success
  end

  test "should get help" do
    get statc_pages_help_url
    assert_response :success
  end
end
