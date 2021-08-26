require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test 'deberia tener un precio positivo' do 
    product = products(:one)
    product.price = -1
    assert_not product.valid?
  end

  test 'deberia filtrar productos por nombre' do 
    assert_equal 2, Product.filter_by_title('tv').count
  end

  test 'deberia de filtrar productos por nombre y abreviacion' do 
    assert_equal [products(:another_tv), products(:one)], Product.filter_by_title('tv').sort
  end

  test 'deberia de filtrar por precios y agruparlos' do 
    assert_equal [products(:two), products(:one)], Product.above_or_equal_to_price(200).sort
  end

  test 'debeira de filtrar por precio inferrior y agruparlo' do 
    assert_equal [products(:another_tv)], Product.below_or_equal_to_price(200).sort
  end

  test 'deberia ordernar los productos a los mas recientes' do
    products(:two).touch
    assert_equal [products(:another_tv), products(:one), products(:two)], Product.recent.to_a
  end
end
