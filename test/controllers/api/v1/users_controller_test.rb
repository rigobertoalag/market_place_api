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

  test "el usuario deberia de actualizar" do
    patch api_v1_user_url(@user), params: { user: { email: @user.email, password: "123456" } },
                                  headers: { Authorization: JsonWebToken.encode(user_id: @user.id)}, as: :json
    assert_response :success
  end

  test "el usuario NO deberia actualizar con un correo invalido" do 
    patch api_v1_user_url(@user), params: { user: { email: "emailinvalido.com", password: "123456" } }, 
                                  headers: { Authorization: JsonWebToken.encode(user_id: @user.id)},as: :json
    assert_response :unprocessable_entity
  end

  test "deberia de destruir al usurio" do 
    assert_difference('User.count', -1) do
      delete api_v1_user_url(@user), headers: { Authorization: JsonWebToken.encode(user_id: @user.id) }, as: :json
    end
    assert_response :no_content
  end

  test 'deberia de actualizar el usuario' do
    patch api_v1_user_url(@user), params: { user: { email: @user.email}}, 
                                headers: { Authorization: JsonWebToken.encode(user_id: @user.id)}, as: :json

    assert_response :success
  end

  test 'NO deberia de actualizar el usuario' do 
    patch api_v1_user_url(@user), params:{ user:{ email: @user.email} }, as: :json
    assert_response :forbidden
  end

  test 'deberia eliminar el usuario' do 
    assert_difference('User.count', -1) do
      delete api_v1_user_url(@user), headers: { Authorization: JsonWebToken.encode(user_id: @user.id) }, as: :json
    end
    assert_response :no_content
  end

  test 'NO deberia eliminar al usuario' do 
    assert_no_difference('User.count') do 
      delete api_v1_user_url(@user), as: :json
    end
    assert_response :forbidden
  end
end
