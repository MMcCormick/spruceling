class PagesController < ApplicationController
  layout :determine_layout

  def home
  end

  private

  def determine_layout
    signed_in? ? 'application' : 'splash'
  end
end
