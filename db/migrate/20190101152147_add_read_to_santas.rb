class AddReadToSantas < ActiveRecord::Migration[5.2]
  def change
    add_column :santa, :read, :boolean, default: false
  end
end
