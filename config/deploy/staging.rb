server "18.138.191.251", user: "deploy", roles: %w{app web db}
set :rails_env, :staging
set :branch, 'fix/seamless-transfer'
