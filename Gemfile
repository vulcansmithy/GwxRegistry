source "https://rubygems.org"

ruby "2.5.1"

gem "rails", "~> 5.2.2"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem 'bcrypt', '~> 3.1', '>= 3.1.12'
gem "bootsnap", ">= 1.1.0", require: false
gem 'rack-cors', require: 'rack/cors'
gem "versionist", "1.7.0"                    
gem "rswag",      "2.0.5"                    

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails",   "3.8.1"
  gem "guard-rspec",   "4.7.3"
  gem "awesome_print", "1.8.0"
  gem "pry"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "simplecov", "0.16.1", require: false
  gem "faker", "1.9.1"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

