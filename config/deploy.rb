require 'bundler/capistrano'
set :bundle_flags, '--deployment --quiet --binstubs'
set (:bundle_cmd) { "#{release_path}/bin/bundle" }

set :whenever_command, 'bundle exec whenever --set environment=production'
require 'whenever/capistrano'

require 'sidekiq/capistrano'

server 'libreunir.com', :web, :app, :db, primary: true

set :application, 'libreunir'
set :user, 'deployer'
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, :git
set :repository, 'git://github.com/cirope/libreunir.git'
set :branch, 'master'

after 'deploy:restart', 'deploy:cleanup'

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: { no_release: true } do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  # Rails 4 Fix
  namespace :assets do
    task :precompile, :roles => assets_role, :except => { :no_release => true } do
      run <<-CMD.compact
        cd -- #{latest_release.shellescape} &&
        #{rake} RAILS_ENV=#{rails_env.to_s.shellescape} #{asset_env} assets:precompile
      CMD
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read('config/app_config.example.yml'), "#{shared_path}/config/app_config.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after 'deploy:setup', 'deploy:setup_config'

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/app_config.yml #{release_path}/config/app_config.yml"
  end
  after 'deploy:finalize_update', 'deploy:symlink_config'

  desc 'Make sure local git is in sync with remote.'
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts 'WARNING: HEAD is not the same as origin/master'
      puts 'Run `git push` to sync changes.'
      exit
    end
  end
  before 'deploy', 'deploy:check_revision'

  desc 'Creates the synmlink to tmp/pids'
  task :create_tmp_pids_symlink, roles: :app, except: { no_release: true } do
    run "mkdir -p #{release_path}/tmp"
    run "mkdir -p #{shared_path}/tmp/pids"
    run "ln -s #{shared_path}/tmp/pids #{release_path}/tmp/pids"
  end
  after 'deploy:update_code', 'deploy:create_tmp_pids_symlink'
end
