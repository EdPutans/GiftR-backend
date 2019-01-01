class SantaSerializer < ActiveModel::Serializer
  # belongs_to :receiver
  # belongs_to :gifter
  attributes :id, :receiver_id, :gifter_id, :deadline, :budget, :gifter, :receiver

    def details
        return {
          # 'gifter' => {
          # id: object.gifter.id,
          # # age: object.gifter.age,
          # # first_name: object.gifter.first_name,
        #   # # last_name: object.gifter.last_name
        # },
        'receiver' =>{
          id: object.receiver.id,
          age: object.receiver.age,
          first_name: object.receiver.first_name,
          last_name: object.receiver.last_name,
          gifts: object.receiver.gifts
        }}
      end
end
