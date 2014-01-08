set :stage, :production
set :rails_env, 'production'
set :branch, 'intranet'

role :all, %w{10.241.161.237}
#role :web, %w{10.1.74.147}
#role :app, %w{10.241.161.237}
#role :db,  %w{10.241.161.238}

server '10.241.161.237', user: 'deployer', roles: %w{web app db}
