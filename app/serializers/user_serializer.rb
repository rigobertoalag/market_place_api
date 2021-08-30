class UserSerializer
  include JSONAPI::Serializer
  attributes :email
  has_many :products 

  cache_options enabled: true, cache_length: 12.hours
end
