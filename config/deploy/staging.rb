set :stage, :production
set :rails_env, 'production'

role :all, %w{prueba.libreunir.com}

server 'prueba.libreunir.com', user: 'deployer', roles: %w{web app db}
