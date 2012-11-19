module UserHelper

  def avatar(user, options)
    if user.fb_use_image
      facebook_profile_image_tag("#{user.fb_uid}.jpg", options)
    elsif user.avatar?
      user.avatar.path
    end
  end

end
