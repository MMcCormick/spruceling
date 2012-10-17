class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit_information
    @user = current_user
  end

  def update_information
    if params[:address]
      current_user.update_address(params[:address])
    end
    respond_to do |format|
      if current_user.save
        format.html { redirect_to user_path current_user, :notice => 'Information successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to edit_user_information_path, :notice => 'There was an error updating your information.' }
        format.json { render :json => current_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_stripe
    respond_to do |format|
      if current_user.update_stripe(params[:stripeToken])
        current_user.save
        format.html { redirect_to cart_path, :notice => 'Credit card information was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to cart_path, :notice => 'There was an error updating your credit card information.' }
        format.json { render :json => current_user.errors, :status => :unprocessable_entity }
      end
    end
  end
end
