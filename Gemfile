source :rubygems

ruby '1.9.3'

gem 'bundler'
gem 'rails', '~> 3.2.13.rc2'

gem 'jquery-rails'
gem "devise", ">= 2.1.2"
gem 'yajl-ruby' # json
gem 'rack-contrib'
gem 'soulmate', '1.0.0', :require => 'soulmate/server' # Redis based autocomplete storage
gem 'chronic' # Date/Time management

gem 'dalli' # memcache

gem 'stripe' # payments
gem 'cancan'
gem 'stamps', :git => 'https://github.com/marbemac/stamps.git'
gem 'cloudinary' # images
gem 'carrierwave' # images
gem 'sendgrid'
gem "haml-rails", ">= 0.3.4"
gem 'omniauth'
gem 'oauth2'
gem 'omniauth-facebook'
gem 'koala', '1.5' # facebook graph api support
gem 'activerecord-postgres-hstore', git: 'git://github.com/engageis/activerecord-postgres-hstore.git'
gem 'activerecord-postgres-array'
gem 'annotate'
gem "pg"
gem 'kaminari'
gem "friendly_id", "~> 4.0.1"
gem 'sidekiq' # background jobs
gem 'sinatra' # for sidekiq
gem 'slim' # for sidekiq
gem 'cache_digests'
gem 'mechanize'
gem 'compass-rails'
gem 'zurb-foundation', '3.2.5'
gem 'font-awesome-rails'
gem 'simple_form'
gem 'nested_form'
gem 'awesome-usps', git: 'https://github.com/turbovote/awesome-usps.git'
gem 'sass-rails',   '~> 3.2.3'
gem 'activeadmin'
gem 'net-ping'

gem 'capistrano'

group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-fileupload-rails'
end

group :development do
  gem 'rack-mini-profiler'
  gem 'foreman'
  gem "rspec-rails", ">= 2.11.0"
  gem "factory_girl_rails", ">= 4.0.0"
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'rb-fsevent', :require => false
  gem 'thin'
  gem 'pry-rails', :group => :development
end

group :test do
  gem "rspec-rails", ">= 2.11.0"
  gem "capybara", ">= 1.1.2"
  gem "email_spec", ">= 1.2.1"
  gem "cucumber-rails", ">= 1.3.0", :require => false
  gem "launchy", ">= 2.1.2"
  gem "factory_girl_rails", ">= 4.0.0"
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'database_cleaner'
  gem 'thin'
end

group :staging do
  gem 'rack-mini-profiler'
end

group :production, :staging do
  gem "rack-timeout"
end

#gem 'memcachier' # modify ENV variables to make dalli work with memcachier
#gem 'newrelic_rpm', '~> 3.5.0'
#gem 'airbrake'