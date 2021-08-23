require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'deberia de mostrar el usuario #show' do 
    get api_v1_user_url(@user), as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body)
    assert_equal @user.email, json_response['email']
  end

  test "deberia crear un usuario" do
    assert_difference('User.count') do
      post api_v1_users_url, params: { user: { email: "test@test.org", password: "123456" } }, as: :json
    end
    assert_response :created
  end

  test "NO deberia de crear un usuario con un email ya existente" do 
    assert_no_difference('User.count') do
      post api_v1_users_url, params: { user: { email: @user.email, password: "123456" } }, as: :json
    end
    assert_response :unprocessable_entity
  end
end