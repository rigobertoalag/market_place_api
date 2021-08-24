require "test_helper"

class Api::V1::TokensControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @user = users(:one)
  end

  test "deberiamos obtener el JWT" do 
    post api_v1_tokens_url, params: { user: { email: @user.email, password: "superpass"} }, as: :json

    assert_response :success

    json_response = JSON.parse(response.body)
    assert_not_nil json_response['token']
  end

  test "NO deberia obtener el JWT" do 
    post api_v1_tokens_url, params: { user: { email: @user.email, password: "malpass"} }, as: :json

    assert_response :unauthorized
  end
end
