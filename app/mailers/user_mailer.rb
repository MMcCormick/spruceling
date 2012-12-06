class UserMailer < ActionMailer::Base
  default from: "support@spruceling.com"

  def follow_up(user_id)
    @user = User.find(user_id)
    mail(:to => @user.email, :subject => "How was your Spruceling experience?")
  end

  def unfinished_box(user_id, box_id)
    @user = User.find(user_id)
    @box = Box.find(box_id)
    mail(:to => @user.email, :subject => "You have an unfinished box!")
  end
end
