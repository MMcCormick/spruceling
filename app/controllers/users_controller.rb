class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
    authorize! :manage, :all
  end

  def show
    @user = User.find(params[:id])
    @boxes = @user.boxes.active

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boxes }
    end
  end

  def edit_address
    @user = current_user
  end

  def edit_payment
    @user = current_user
  end

  def update_address
    respond_to do |format|
      if current_user.update_address(params.slice(:address1, :address2, :city, :state, :zip_code, :full_name))
        current_user.save
        format.html { redirect_to :back, :notice => 'Information successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, :alert => 'There is an error in your shipping address.' }
        format.json { render :json => current_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_stripe
    respond_to do |format|
      if current_user.update_stripe(params[:stripeToken])
        current_user.save
        format.html { redirect_to :back, :notice => 'Credit card information was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, :notice => 'There was an error updating your credit card information.' }
        format.json { render :json => current_user.errors, :status => :unprocessable_entity }
      end
    end
  end
end

