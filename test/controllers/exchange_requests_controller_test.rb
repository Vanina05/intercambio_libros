require "test_helper"

class ExchangeRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get exchange_requests_create_url
    assert_response :success
  end

  test "should get index" do
    get exchange_requests_index_url
    assert_response :success
  end

  test "should get update" do
    get exchange_requests_update_url
    assert_response :success
  end
end
