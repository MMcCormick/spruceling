class ApplicationController < ActionController::Base
  before_filter :five_dollars, :init

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
