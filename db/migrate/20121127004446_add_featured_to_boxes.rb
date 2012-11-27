class AddFeaturedToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :is_featured, :boolean, :default => false
  end
end
