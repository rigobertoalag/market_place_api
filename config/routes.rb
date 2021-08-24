Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :tokens, only:[:create]
      resources :products, only: [:show, :index]
    end
  end
end


# Creando productos
# Crear productos es un poco más complejo porque necesitaremos una configuración adicional. La estrategia que seguiremos es asignar el producto creado al usuario que pertenece al token JWT proporcionado en la cabecera HTTP Authorization.