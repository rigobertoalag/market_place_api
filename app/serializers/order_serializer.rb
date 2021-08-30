class OrderSerializer
  include JSONAPI::Serializer
  belongs_to :user
  has_many :products

  cache_options enabled: true, cache_length: 12.hours
end
