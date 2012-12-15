class CartsController < ApplicationController
  def buy
    session[:buy_box] = params[:box_id] if params[:box_id]
    @box = Box.find(session[:buy_box])

    if signed_in? && @box && @box.user_id == current_user.id
      redirect_to :back, :alert => 'You cannot buy your own box! That would be silly, wouldn\'t it?'
    end

    @fullscreen = true
    @show_shipping = signed_in? ? true : false
    @completed_shipping = signed_in? && current_user.address ? true : false
    @show_payment = @completed_shipping ? true : false
    @completed_payment = signed_in? && current_user.stripe_customer_id ? true : false
    @show_review = @completed_payment ? true : false
  end

  def show
    @cart = current_user.cart

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @cart }
    end
  end

  def add
    @cart = current_user.cart

    respond_to do |format|
      if @cart.add_box(params[:box_id])
        @cart.save
        format.html { redirect_to cart_path, :notice => 'Cart was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to cart_path, :alert => 'There was an error adding that box to your cart.' }
        format.json { render :json => @cart.errors, :status => :unprocessable_entity }
      end
    end
  end

  def remove
    @cart = current_user.cart

    respond_to do |format|
      if @cart.remove_box(params[:box_id])
        @cart.save
        format.html { redirect_to cart_path, :notice => 'Cart was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to cart_path, :notice => 'There was an error removing that box from your cart.' }
        format.json { render :json => @cart.errors, :status => :unprocessable_entity }
      end
    end
  end
end
