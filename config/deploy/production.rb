set :stage, :production
set :rails_env, 'production'

role :web, %w{deployer@libreunir.com}
role :app, %w{deployer@libreunir.com}
role :db,  %w{deployer@libreunir.com}

server 'libreunir.com', user: 'deployer', roles: %w{web app db}
