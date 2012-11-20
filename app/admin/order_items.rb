ActiveAdmin.register OrderItem do
  scope :pending

  index do
    column :id
    column :status
    column :empty_tracking
    column :full_tracking
    column :box do |oi|
      link_to "Box ##{oi.box.id}", box_path(oi.box)
    end
    column :order do |oi|
      link_to "Order ##{oi.order.id}", order_path(oi.order)
    end
    column :buyer do |oi|
      link_to oi.buyer.email, user_path(oi.buyer)
    end
    column :seller do |oi|
      link_to oi.seller.email, user_path(oi.seller)
    end
    column "Paid Seller?", :paid
    default_actions
  end

  filter :status, :as => :select, :collection => OrderItem.all_statuses

  form :partial => "form"
end
