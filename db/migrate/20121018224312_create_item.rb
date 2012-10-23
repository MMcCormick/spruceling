class CreateItem < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :gender
      t.string :size
      t.string :brand
      t.boolean :new_with_tags
      t.string :status, :default => 'active'
      t.references :user
      t.references :box
      t.references :item_type
    end

    add_index :items, :user_id
    add_index :items, :box_id
    add_index :items, :item_type_id
  end
end
