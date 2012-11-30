desc "Email users with unfinished boxes"

task :email_unfinished => :environment do
  boxes = Box.where(:status => "draft")
  uids = []
  boxes.each do |b|
    UserMailer.unfinished_box(b.user_id, b.id).deliver unless uids.include?(b.user_id)
    uids << b.user_id
  end
end