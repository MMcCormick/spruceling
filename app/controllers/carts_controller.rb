class CartsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @cart = current_user.cart

    respond_to do |format|
      format.html # show.html.erb
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
        format.html { redirect_to cart_path, :notice => 'There was an error adding that box to your cart.' }
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
