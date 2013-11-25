set :stage, :production
set :rails_env, 'production'

role :all, %w{libreunir.com}

server 'libreunir.com', user: 'deployer', roles: %w{web app db}
