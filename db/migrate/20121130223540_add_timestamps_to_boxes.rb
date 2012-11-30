class AddTimestampsToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :created_at, :datetime
    add_column :boxes, :updated_at, :datetime
  end
end
