class AddHasImageToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :has_image, :boolean
  end
end
