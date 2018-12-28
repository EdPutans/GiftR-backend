class Santa < ApplicationRecord
  belongs_to :receiver, class_name: "User", foreign_key: :receiver_id
  belongs_to :gifter, class_name: "User", foreign_key: :gifter_id
end
