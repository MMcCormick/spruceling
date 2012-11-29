module UserHelper

  def user_avatar(user, options)
    if user.fb_use_image
      options.delete(:gravity)
      facebook_profile_image_tag("#{user.fb_uid}.png", options)
    elsif user.avatar.present?
      cl_image_tag(user.avatar_image, options)
    else
      options.delete(:gravity)
      gravatar_profile_image_tag(user.email, options.merge(:default_image => :mm))
    end
  end

  def user_avatar_path(user, options)
    if user.fb_use_image
      options.delete(:gravity)
      cl_image_path("#{user.fb_uid}.png", {:type=>:facebook}.merge(options))
    elsif user.avatar.present?
      cl_image_path(user.avatar_image, options)
    else
      options.delete(:gravity)
      cl_image_path(Digest::MD5.hexdigest(user.email.strip.downcase), {:default_image => :mm, :type=>:gravatar, :format=>:png}.merge(options))
    end
  end

  def user_balance(user, precision=2)
    number_to_currency(user.balance, :precision => precision)
  end
end
