# This migration comes from attachinary (originally 20120612112526)
class AddTimestampsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :created_at, :datetime
    add_column :orders, :updated_at, :datetime
  end
end
