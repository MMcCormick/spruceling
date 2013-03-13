require 'bundler/capistrano'
#require 'sidekiq/capistrano'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :use_sudo, true
set :domain, '198.211.110.136'
set :application, 'spruceling'
set :repository,  'https://marbemac@github.com/whoot/spruceling.git'
set :deploy_to, "/var/www/#{application}"
set :branch, 'master'

set :scm, :git
set :scm_verbose, true

# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true

set :deploy_via, :remote_cache
set :use_sudo, true
set :keep_releases, 3
set :user, 'deployer'

set :bundle_without, [:development, :test]

set :rake, "#{rake} --trace"

set :default_environment, {
    'PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p392@Spruceling/bin:/usr/local/rvm/rubies/ruby-1.9.3-p392/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games",
    'RUBY_VERSION' => 'ruby 1.9.3',
    'GEM_HOME'     => '/usr/local/rvm/gems/ruby-1.9.3-p392@Spruceling',
    'GEM_PATH'     => '/usr/local/rvm/gems/ruby-1.9.3-p392@Spruceling',
    'BUNDLE_PATH'  => '/usr/local/rvm/gems/ruby-1.9.3-p392@Spruceling'  # If you are using bundler.
}

after 'deploy:setup' do
  sudo "chown -R #{user} #{deploy_to} && chmod -R g+s #{deploy_to}"
end

namespace :deploy do
  desc <<-DESC
  Restart Passenger
  DESC
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end