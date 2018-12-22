class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :age, :gifts, :password_digest, :friendships, :back_friendships
end
