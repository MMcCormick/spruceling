class CreateBoxesCarts < ActiveRecord::Migration
  def change
    create_table :boxes_carts, :id => false do |t|
      t.references :cart, :null => false
      t.references :box, :null => false
    end

    add_index :boxes_carts, :cart_id
    add_index :boxes_carts, :box_id
    add_index :boxes_carts, [:cart_id, :box_id], unique: true
  end
end