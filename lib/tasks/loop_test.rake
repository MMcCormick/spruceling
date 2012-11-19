desc "Test Loop model"
task :loop_test => :environment do
  #Mongoid.default_session.collections.select {|c| c.name !~ /system/ }.each(&:drop)

  50.times do |n|
    FactoryGirl.create(:user)
  end

  User.all.each do |u|
    puts u.name
    (2 + rand(5)).times do
      genders = %w(m f)
      sizes = Item.all_sizes
      box = u.boxes.new(:gender => genders[rand(2)], :size => sizes[rand(Item.all_sizes.length)], :seller_price => 30.00)
      box.photos.new(:image => 'foo')
      u.save
      puts "  gender: #{box.gender}, size: #{box.size}"
    end
  end
end