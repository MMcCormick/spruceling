class AddBrandToItem < ActiveRecord::Migration
  def change
    add_column :items, :brand_id, :integer
    remove_column :items, :brand

    add_index :items, :brand_id
  end
end
