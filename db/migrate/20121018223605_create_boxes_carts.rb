class CreateBoxesCarts < ActiveRecord::Migration
  def change
    create_table :boxes_carts, :id => false do |t|
      t.references :cart, :null => false
      t.references :box, :null => false
    end
  end
end