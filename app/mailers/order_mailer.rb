class OrderMailer < ActionMailer::Base
  default from: "support@spruceling.com"

  def receipt(order_id)
    @order = Order.find(order_id)
    @user = @order.user
    mail(:to => @order.user.email, :subject => "Your receipt for Spruceling order #{@order.id}")
  end
end
