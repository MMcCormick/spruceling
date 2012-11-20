class PhotosController < ApplicationController
  before_filter :authenticate_user!

  def create
    photos = []
    params[:photos].each do |photo|
      new_photo = Photo.create(:image => photo, :imageable_id => params[:imageable_id], :imageable_type => params[:imageable_type])
      photos << {
        :url => new_photo.image_url,
        :image_name => new_photo.image_name,
        :html => render_to_string(:partial => 'cover_photo', :locals => {:photo => new_photo, :remove_link => true})
      }
    end

    render :json => photos
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
  end
end
