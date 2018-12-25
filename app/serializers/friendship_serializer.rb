class FriendshipSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :friend_id, :confirmed, :rejected, :user, :friend
end
