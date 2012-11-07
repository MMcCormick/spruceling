class AddSlugToThredupData < ActiveRecord::Migration
  def change
    add_column :thredup_data, :brand_id, :integer
    add_index :thredup_data, :brand_id
  end
end
