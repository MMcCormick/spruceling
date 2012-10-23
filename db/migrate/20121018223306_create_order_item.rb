class CreateOrderItem < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :box
      t.references :order
    end

    add_index :order_items, :box_id, unique: true
    add_index :order_items, :order_id
  end
end
