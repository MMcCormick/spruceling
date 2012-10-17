class HomeController < ApplicationController
  layout :determine_layout

  def index
    if signed_in?
      render "home"
    else
      render "splash"
    end
  end

  private

  def determine_layout
    signed_in? ? 'application' : 'splash'
  end
end
