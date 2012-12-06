desc "Follow up with users who signed up recently"

task :follow_up => :environment do
  User.where("created_at > ? AND created_at < ?", Time.now - 2.days, Time.now - 1.day).each do |user|
    UserMailer.follow_up(user.id).deliver
  end
end