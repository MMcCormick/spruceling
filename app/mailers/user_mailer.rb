class UserMailer < ActionMailer::Base
  default from: "support@spruceling.com"

  def unfinished_box(user_id, box_id)
    @user = User.find(user_id)
    @box = Box.find(box_id)
    mail(:to => @user.email, :subject => "You have an unfinished box!")
  end
end
