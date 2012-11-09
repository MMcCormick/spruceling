USPS.configure do |config|
  config.username = "209SPRUC6859"
  config.testing  = true if %w(testing development).include? Rails.env
end