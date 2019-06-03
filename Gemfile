source 'https://rubygems.org'
ruby '2.5.1'

gem 'active_model_serializers', '0.10.8'    # https://github.com/rails-api/active_model_serializers
gem 'appsignal'
gem 'attr_encrypted', '3.1.0'               # https://github.com/attr-encrypted/attr_encrypted
gem 'base32'
gem 'bcrypt', '~> 3.1', '>= 3.1.12'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'digest-sha3'
gem 'doorkeeper'
gem 'fast_jsonapi', '1.3'                   # https://github.com/Netflix/fast_jsonap
gem 'fcm'                                   # https://github.com/spacialdb/fcm
gem 'jwt', '2.1.0'                          # https://github.com/jwt/ruby-jwt
gem 'nem-ruby'                              # https://github.com/44uk/nem-ruby
gem 'rails', '~> 5.2.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rack-cors', '1.0.2', require: 'rack/cors'
gem "rbnacl", "6.0.1"                       # https://github.com/crypto-rb/rbnacl
gem 'rswag', '2.0.5'                        # https://github.com/domaindrivendev/rswag
gem 'rspec-core'
gem 'simple_command'                        # https://github.com/nebulab/simple_command
gem 'versionist', '1.7.0'                   # https://github.com/bploetz/versionist
gem 'doorkeeper'
gem 'will_paginate', '~> 3.1.0'
gem 'carrierwave', '~> 1.0'
gem 'fog-aws'

group :development, :test do
  gem 'awesome_print', '1.8.0'              # https://github.com/awesome-print/awesome_print
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'guard-rspec', '4.7.3'              # https://github.com/guard/guard-rspec
  gem 'pry'
  gem 'rspec-rails', '3.8.1'              # https://github.com/rspec/rspec-rails
end

group :development do
  gem 'capistrano', '~> 3.10', require: false
  gem 'capistrano-rbenv', '~> 2.1', require: false
  gem 'capistrano-rbenv-install', '~> 1.2.0', require: false
  gem 'capistrano-bundler', '~> 1.5', require: false
  gem 'capistrano3-puma', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails', '4.11.1'           # https://github.com/thoughtbot/factory_bot_rails
  gem 'faker', '1.9.1'                        # https://github.com/stympy/faker
  gem 'shoulda-matchers'
  gem 'simplecov', '0.16.1', require: false   # https://github.com/colszowka/simplecov
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

