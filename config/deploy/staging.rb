server "13.229.137.10", user: "ubuntu", roles: %w{app web}
set :stage, :staging
set :rails_env, :staging
set :branch, 'develop'
