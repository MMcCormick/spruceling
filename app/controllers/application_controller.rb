class ApplicationController < ActionController::Base
  before_filter :five_dollars, :init
  after_filter :store_location

  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def after_update_path_for(resource)
    session[:previous_url] || root_path
  end

  def five_dollars
    if session[:five_dollars] && current_user && current_user.balance == 0
      current_user.credit_account(5.00)
      current_user.save
      session[:five_dollars] = nil
    end
  end

  def authenticate_admin_user! #use predefined method name
    redirect_to '/' and return if user_signed_in? && !current_user.role?('admin')
    authenticate_user!
  end
  def current_admin_user #use predefined method name
    return nil if user_signed_in? && !current_user.role?('admin')
    current_user
  end

  def init
    @fullscreen = false
  end
end
