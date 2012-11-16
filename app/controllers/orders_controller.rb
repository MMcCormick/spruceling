class OrdersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @orders = current_user.orders

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  def show
    @order = Order.find(params[:id])
    authorize! :read, @order

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @order }
    end
  end

  def create
    @order = Order.generate(current_user)

    respond_to do |format|
      if @order.valid? && @order.charge
        @order.process
        @order.save
        current_user.save

        @order.send_confirmations

        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { redirect_to cart_path, :alert => 'Order was not created.' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
end
