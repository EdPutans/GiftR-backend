class GiftSerializer < ActiveModel::Serializer
  attributes :id, :name, :url, :img_url, :rating, :description, :price, :user_id

end
