source "https://rubygems.org"

ruby "2.5.1"

gem "rails",     "~> 5.2.2"
gem "pg",        ">= 0.18", "< 2.0"
gem "puma",      "~> 3.11"
gem "bcrypt",    "~> 3.1", ">= 3.1.12"
gem "jwt",       "2.1.0"                       # https://github.com/jwt/ruby-jwt
gem "bootsnap",  ">= 1.1.0", require: false
gem "rack-cors", "1.0.2",    require: "rack/cors"
gem "simple_command"                           # https://github.com/nebulab/simple_command
gem "versionist", "1.7.0"                      # https://github.com/bploetz/versionist
gem "rswag",      "2.0.5"                      # https://github.com/domaindrivendev/rswag

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails",   "3.8.1"                 # https://github.com/rspec/rspec-rails
  gem "guard-rspec",   "4.7.3"                 # https://github.com/guard/guard-rspec
  gem "awesome_print", "1.8.0"                 # https://github.com/awesome-print/awesome_print
  gem "pry"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "simplecov", "0.16.1", require: false   # https://github.com/colszowka/simplecov
  gem "faker", "1.9.1"                        # https://github.com/stympy/faker
  gem "factory_bot_rails", "4.11.1"           # https://github.com/thoughtbot/factory_bot_rails
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

