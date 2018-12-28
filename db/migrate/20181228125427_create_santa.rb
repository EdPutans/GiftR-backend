class CreateSanta < ActiveRecord::Migration[5.2]
  def change
    create_table :santa do |t|
      t.string :receiver_id
      t.string :gifter_id
      t.float :budget
      t.datetime :deadline
    end
  end
end
