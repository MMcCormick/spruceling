desc "Test Loop model"

task :fake_boxes => :environment do
  #Mongoid.default_session.collections.select {|c| c.name !~ /system/ }.each(&:drop)

  unless User.all.length > 40
    25.times do |n|
      FactoryGirl.create(:user)
    end
  end

  User.all.each do |u|
    puts u.name
    (2 + rand(5)).times do
      genders = %w(m f)
      sizes = Item.all_sizes
      box = u.boxes.new(:gender => genders[rand(2)], :size => sizes[rand(Item.all_sizes.length)], :seller_price => rand(20..40))
      box.photos.new(:image => 'foo')
      u.save
      (5 + rand(10)).times do
        item = box.items.new(:gender => box.gender, :size => box.size, :item_type_id => 1+rand(31), :brand_id => 1, :new_with_tags => false)
        item.user = box.user
      end
      box.save
      puts "  gender: #{box.gender}, size: #{box.size}"
    end
  end
end