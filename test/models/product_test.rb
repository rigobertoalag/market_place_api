require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test 'deberia tener un precio positivo' do 
    product = products(:one)
    product.price = -1
    assert_not product.valid?
  end
end
