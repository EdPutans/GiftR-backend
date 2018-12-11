class CreateGifts < ActiveRecord::Migration[5.2]
  def change
    create_table :gifts do |t|
      t.integer :user_id
      t.float :price
      t.string :name
      t.string :url
      t.string :img_url
      t.integer :rating
      t.text :description
      t.timestamps
    end
  end
end
