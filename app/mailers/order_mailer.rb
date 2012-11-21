class OrderMailer < ActionMailer::Base
  default from: "support@spruceling.com"

  def receipt(order_id)
    @order = Order.find(order_id)
    @user = @order.user
    mail(:to => @order.user.email, :subject => "Your receipt for Spruceling Order ##{@order.id}")
  end

  # Emails the sender. Accepts an order id and a user id
  def sold(order_id, sender_id)
    @order = Order.find(order_id)
    @sender = User.find(sender_id)
    @order_items = @order.order_items.select{|oi| oi.box.user.id == @sender.id}
    @boxes = @order_items.map{|oi| oi.box}
    mail(:to => @sender.email, :subject => "Your Spruceling box has found a pages!")
  end

  def empty_box_delivered(order_item_id)
    @order_item = OrderItem.find(order_item_id)
    @box = @order_item.box
    mail(:to => @order_item.box.user.email, :subject => "Your empty Spruceling box has arrived!")
  end

  def full_box_shipped(order_item_id)
    @order_item = OrderItem.find(order_item_id)
    @box = @order_item.box
    mail(:to => @order_item.order.user.email, :subject => "Your Spruceling box has shipped!")
  end

  def full_box_delivered(order_item_id)
    @order_item = OrderItem.find(order_item_id)
    @box = @order_item.box
    mail(:to => @order_item.order.user.email, :subject => "Your Spruceling box has arrived!")
  end
end
