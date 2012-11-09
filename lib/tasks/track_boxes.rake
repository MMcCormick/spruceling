desc "Track boxes that have been bought"
task :track_boxes => :environment do
  OrderItem.where(:status => "sold").each do |order|
    request = USPS::Request::TrackingLookup.new(order.tracking_number)
    response = request.send!
  end
end