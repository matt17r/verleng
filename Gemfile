source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.3.1"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails", "~> 0.1.0"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", ">= 0.8.3"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", ">= 0.4.0"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails", ">= 0.1.0"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

gem "sprockets-rails", "~>3.4.2"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

gem "googleauth", "~> 1.2.0"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Use Sass to process CSS
# gem "sassc-rails", "~> 2.1"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem "clearance", "~> 2.5"
gem "faraday", "~> 1.8"
gem "ohmysmtp-rails", "~> 0.1.9"

group :development, :test do
  # Start debugger with binding.b [https://github.com/ruby/debug]
  gem "debug", ">= 1.0.0", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails", "~> 2.7"
  gem "standard", require: false
end

group :development do
  gem "capistrano", "~> 3.17"
  gem "capistrano-rails", "~> 1.6"
  gem "capistrano-passenger", "~> 0.2.1"
  gem "capistrano-rbenv", "~> 2.2"
  gem "foreman"
  gem "guard"
  gem "guard-minitest"
  gem "rack-mini-profiler", ">= 2.3.3"
  gem "terminal-notifier-guard"
  gem "web-console", ">= 4.1.0"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", ">= 3.26"
  gem "minitest-reporters"
  gem "selenium-webdriver"
  gem "webdrivers"
end
