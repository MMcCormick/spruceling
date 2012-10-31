class AddPriceTotalToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :seller_price, :decimal, :precision => 8, :scale => 2, :null => false
  end
end
