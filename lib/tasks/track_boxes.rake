desc "Track boxes that have been bought"
task :track_boxes => :environment do
  OrderItem.track_boxes
end