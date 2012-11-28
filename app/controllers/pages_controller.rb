class PagesController < ApplicationController
  def home
    @featured_boxes = Box.featured
  end

  def promo
    session[:five_dollars] = true
    redirect_to new_user_registration_path
  end
end
