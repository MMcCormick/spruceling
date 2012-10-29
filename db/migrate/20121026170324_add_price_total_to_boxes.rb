class AddPriceTotalToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :price_total, :decimal, :precision => 8, :scale => 2, :null => false
  end
end
