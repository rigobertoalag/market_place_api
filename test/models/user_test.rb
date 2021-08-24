require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'usuario con un correo valido deberia de ser valido' do
    user = User.new(email: 'test@test.com', password_digest: 'test')
    assert user.valid?    
  end

  test 'usuario con un correo invalido deberia de ser invalido' do
    user = User.new(email: 'test', password_digest: 'test')
    assert_not user.valid?
  end

  test 'usuario con correo ya registro deberia de ser invalido' do
    user = User.new(email: 'one@one.org', password_digest: 'test')
    assert_not user.valid?
  end

  test 'eliminar un usuario deberia de eliminar su producto ligado' do
    assert_difference('Product.count', -1) do
      users(:one).destroy
    end
  end
end
