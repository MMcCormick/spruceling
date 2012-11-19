class AddReviewToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :review, :string
  end
end
