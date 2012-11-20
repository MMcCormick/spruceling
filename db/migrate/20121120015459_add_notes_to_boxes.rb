class AddNotesToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :notes, :string
  end
end
