class CreateThredupData < ActiveRecord::Migration
  def change
    create_table :thredup_data do |t|
      t.string :brand_name
      t.string :item_type
      t.string :gender
      t.string :size
      t.decimal :thredup_price, :precision => 8, :scale => 2
      t.decimal :retail_price, :precision => 8, :scale => 2
      t.boolean :new_with_tags, :default => false
      t.string :url
    end

    add_index :thredup_data, :url
  end
end
