class User < ApplicationRecord
  has_secure_password
  has_many :gifts
  has_many :friendships
  has_many :back_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :receivers, class_name: "Santa", :foreign_key => 'receiver_id'
  has_many :gifters, class_name: "Santa", :foreign_key => 'gifter_id'
end
