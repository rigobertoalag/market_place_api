require "test_helper"

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @product = products(:one)
  end

  test 'deberia de mostrar todos los productos' do 
    get api_v1_products_url(), as: :json
    assert_response :success
  end

  test 'deberia de mostrar el producto' do 
    get api_v1_product_url(@product), as: :json

    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal @product.title, json_response.dig(:data, :attributes, :title)#['data']['attributes']['title']
    assert_equal @product.user.id.to_s, json_response.dig(:data, :relationships, :user, :data, :id)
    assert_equal @product.user.email, json_response.dig(:included, 0, :attributes, :email)
  end

  test 'deberia crear un producto' do 
    assert_difference('Product.count') do 
      post api_v1_products_url,
            params: { product: { title: @product.title, price: @product.price, published: @product.published } },
            headers: { Authorization: JsonWebToken.encode(user_id: @product.user_id) },
            as: :json
    end
    assert_response :created
  end

  test 'no deberia de crear producto sin un usuario' do
    assert_no_difference('Product.count') do
      post api_v1_products_url,
            params: { product: { title: @product.title, price: @product.price, published: @product.published } },
            as: :json
    end
    assert_response :forbidden
  end

  test 'deberia de actualizar el producto' do 
    patch api_v1_product_url(@product),
          params: { product: { title: @product.title } },
          headers: { Authorization: JsonWebToken.encode(user_id: @product.user_id) },
          as: :json
    assert_response :success
  end

  test 'NO deberia de actualizar el producto ya que el usuario nos es el mismo' do
    patch api_v1_product_url(@product),
          params: { product: { title: @product.title } },
          headers: { Authorization: JsonWebToken.encode(user_id: users(:two).id ) },
          as: :json
    assert_response :forbidden
  end

  test 'deberia de eliminar el producto' do 
    assert_difference('Product.count', -1) do
      delete api_v1_product_url(@product), 
              headers: { Authorization: JsonWebToken.encode(user_id: @product.user_id) },
              as: :json
    end
    assert_response :no_content
  end

  test 'NO deberia eliminar el producto el usuario no es el dueño' do
    assert_no_difference('Product.count') do
      delete api_v1_product_url(@product),
              headers: { Authorization: JsonWebToken.encode(user_id: users(:two).id ) },
              as: :json
    end
    assert_response :forbidden
  end
end
