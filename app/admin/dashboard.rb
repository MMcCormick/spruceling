ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    columns do
       column do
         panel "Pending Order Items" do
           table_for OrderItem.pending.limit(10) do
             column :id do |oi|
               link_to("Order Item ##{oi.id}", admin_order_item_path(oi))
             end
             column :buyer do |oi|
               link_to oi.buyer.email, user_path(oi.buyer)
             end
             column :seller do |oi|
               link_to oi.seller.email, user_path(oi.seller)
             end
           end
           strong { link_to "View All Order Items", admin_order_items_path }
         end
       end

       column do
         panel "Info" do
           para "This is the Spruceling admin page."
         end
       end
    end
  end # content
end
