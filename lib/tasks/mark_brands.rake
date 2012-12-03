desc "Mark brands which have images"

task :mark_brands => :environment do

  confirmed_images = []
  Brand.all.each do |brand|
    if brand.slug
      if FileTest.exists?("#{Rails.root}/public#{brand.icon_path}")
        p "Success: #{brand.slug}"
        brand.has_image = true
        brand.save
        confirmed_images << brand.icon_path
      end
    end
  end

  p "=============We have pics for #{confirmed_images.length} brands============="
  p ""
  p "Here are the unclaimed pics:"

  Dir["#{Rails.root}/public/images/brands/*"].each do |file|
    derived = file.gsub("#{Rails.root}/public", "")
    unless confirmed_images.include? derived
      p derived
    end
  end

  #  good = 'http://www.google.com/index.html'
  #  bad = 'http://www.ruby-lang.org/index.html'
  #
  #  puts "== Good ping, no redirect"
  #
  #  p1 = Net::Ping::HTTP.new(good)
  #  p p1.ping?
  #
  #  puts "== Bad ping"
  #
  #  p2 = Net::Ping::HTTP.new(bad)
  #  p p2.ping?
  #  p p2.warning
  #  p p2.exception
end