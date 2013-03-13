require 'bundler/capistrano'
require 'sidekiq/capistrano'
#require 'capistrano/ext/multistage'

#set :stages, %w(production staging)
#set :default_stage, 'staging'

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

#set :default_environment, {
#    'PATH' => '/usr/local/rbenv:/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
#}

#after 'deploy:update_code', :upload_env_vars

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

#task :upload_env_vars do
#  upload(".env.#{rails_env}", "#{release_path}/.env.#{rails_env}", :via => :scp)
#end