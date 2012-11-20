class AddFullTrackingAndEmptyTrackingToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :full_tracking, :string
    add_column :order_items, :empty_tracking, :string
  end
end
