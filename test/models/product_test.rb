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

  test 'la busqueda no deberia de encontrar videojuegos con menor precio de 100' do
    search_hash = { keyword: 'videogame', min_price: 100 }
    assert Product.search(search_hash).empty?
  end

  test 'la busqueda deberia de encontrar la TV mas barata' do
    search_hash = { keyword: 'tv', min_price: 50, max_price: 150}
    assert_equal [(products(:another_tv))], Product.search(search_hash)
  end

  test 'deberia de traer todos los productos cuando la consulta esta vacia' do
    assert_equal Product.all.to_a, Product.search({})
  end

  test 'la busqueda deberia de filtrar por ids' do
    search_hash = { product_ids: [products(:one).id] }
    assert_equal [products(:one)], Product.search(search_hash)
  end
end
