class CreateSanta < ActiveRecord::Migration[5.2]
  def change
    create_table :santa do |t|
      t.integer :receiver_id
      t.integer :gifter_id
      t.float :budget
      t.datetime :deadline
    end
  end
end
