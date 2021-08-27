require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do 
    @order = orders(:one)
    @product1 = products(:one)
    @product2 = products(:two)
  end

  test 'deberia de poner el total' do 
    order = Order.new user_id: @order.user_id
    order.products << products(:one)
    order.products << products(:two)
    order.save

    assert_equal (@product1.price + @product2.price), order.total
  end

  test 'construye 2 lugraes para la order' do 
    @order.build_placements_with_product_ids_and_quantities [
      { product_id: @product1.id, quantity: 2 },
      { product_id: @product2.id, quantity: 3 }
    ]
    
    assert_difference('Placement.count', 2) do
      @order.save
    end
  end

  test 'la orden deberia de fallar al no tener los suficientes productos disponibles' do 
    @order.placements << Placement.new(product_id: @product1.id, quantity: (1 + @product1.quantity))

    assert_not @order.valid?
  end

  test 'deberia poner el total' do 
    @order.placements = [
      Placement.new(product_id: @product1.id, quantity: 2),
      Placement.new(product_id: @product2.id, quantity: 2)
    ]

    @order.set_total!
    expected_total = (@product1.price * 2) + (@product2.price * 2)

    assert_equal expected_total, @order.total
  end
end
