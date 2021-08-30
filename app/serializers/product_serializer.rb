class ProductSerializer
  include JSONAPI::Serializer
  attributes :title, :price, :published
  belongs_to :user

  cache_options enabled: true, cache_length: 12.hours
end
