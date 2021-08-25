Product.delete_all
User.delete_all

3.times do 
    user = User.create! email: Faker::Internet.email, password: 'test123'
    puts "Usuario creado #{user.email}"

    2.times do 
        product = Product.create!(
            title: Faker::Commerce.product_name,
            price: rand(1.0..100.0),
            published: true,
            user_id: user.id
        )
        puts "Producto creado con el nombre #{product.title} y el precio #{product.price}"
    end
end