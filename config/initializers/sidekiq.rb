Sidekiq.configure_client do |config|
  if ENV["REDISTOGO_URL"]
    config.redis = { :url => ENV["REDISTOGO_URL"], :size => 1 }
  else
    config.redis = { :url => 'redis://localhost:6379', :size => 1 }
  end
end