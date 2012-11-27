class PagesController < ApplicationController
  def home
    @featured_boxes = Box.featured
  end
end
