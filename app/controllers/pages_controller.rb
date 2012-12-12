class PagesController < ApplicationController
  def home
    @featured_boxes = Box.featured
    @charity = Charity.where(:status => "active").first
  end

  def promo
    session[:five_dollars] = true
    flash[:notice] = "Congratulations, you have used promo code '#{params[:code]}'! You will be credited with $5 when you sign up."
    redirect_to new_user_registration_path
  end
end