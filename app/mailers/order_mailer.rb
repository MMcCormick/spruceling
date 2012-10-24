class OrderMailer < ActionMailer::Base
  default from: "support@spruceling.com"

  def receipt(order_id)
    @order = Order.find(order_id)
    @user = @order.user
    mail(:to => @order.user.email, :subject => "Your receipt for Spruceling order #{@order.id}")
  end

  # Emails the sender. Accepts an order id and a user id
  def sold(order_id, user_id)
    @order = Order.find(order_id)
    @user = User.find(user_id)
    @order_items = @order.order_items.select{|oi| oi.box.user.id == @user.id}
    @boxes = @order_items.map{|oi| oi.box}
    mail(:to => @user.email, :subject => "Your Spruceling box has found a home!")
  end

  def empty_box_delivered(order_item_id)
    @order_item = OrderItem.find(order_item_id)
    mail(:to => @order_item.box.user.email, :subject => "Your empty Spruceling box has arrived!")
  end
end
