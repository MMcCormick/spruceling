desc "Mark brands which have images"
require 'net/ping'
include Rails.application.routes.url_helpers

task :mark_brands => :environment do

  count = 0
  Brand.limit(100).each do |brand|
    if brand.slug
      url = "localhost:3000#{brand.icon_path}"
      p "Pinging #{url}..."
      p1 = Net::Ping::HTTP.new(url)
      if p1.ping?
        p "Success!"
        brand.has_image = true
        brand.save
      end
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