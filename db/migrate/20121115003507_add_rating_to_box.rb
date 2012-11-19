class AddRatingToBox < ActiveRecord::Migration
  def change
    add_column :boxes, :rating, :decimal
  end
end
