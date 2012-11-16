ActiveAdmin.register OrderItem do
  scope :pending

  index do
    column :id
    column :status
    column "Paid Seller?", :paid
    column :box do |oi|
      link_to "Box ##{oi.box.id}", box_path(oi.box)
    end
    column :order do |oi|
      link_to "Order ##{oi.order.id}", order_path(oi.order)
    end
    column :buyer do |oi|
      link_to oi.order.user.email, user_path(oi.order.user)
    end
    column :seller do |oi|
      link_to oi.box.user.email, user_path(oi.box.user)
    end
    default_actions
  end

  filter :status, :as => :select, :collection => OrderItem.all_statuses

  form do |f|
    f.inputs "Tracking Numbers" do
      f.input :full_tracking
      f.input :empty_tracking
      f.input :status, :as => :select, :collection => OrderItem.all_statuses
    end
    f.buttons
  end
end
