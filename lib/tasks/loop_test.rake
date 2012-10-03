desc "Test Loop model"
task :loop_test => :environment do
  Mongoid.default_session.collections.select {|c| c.name !~ /system/ }.each(&:drop)

  100.times do |n|
    FactoryGirl.create(:user)
  end

  User.all.each do |u|
    puts u.name
    (1 + rand(3)).times do
      genders = %w(m f)
      sizes = %(12M 18M 2T 3T 4T 5T 6T 7T)
      box = u.boxes.create(:box, :gender => genders[rand(2)], :size => sizes[rand(8)], :level => 1 + rand(3))
      puts "  " + box.attributes
    end
  end
end