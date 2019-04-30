require 'test_helper'

class IndeedControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get indeed_index_url
    assert_response :success
  end

end
