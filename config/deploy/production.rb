server "13.229.58.101", user: "ubuntu", roles: %w{app web}
set :stage, :production
set :rails_env, :production
set :branch, 'master'
