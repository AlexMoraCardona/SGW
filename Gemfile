source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# bootstrap 5
gem "bootstrap"

#agrupar para graficar
gem "groupdate"
#mostrar labels en graficas
gem 'highcharts-rails', '~> 6.0', '>= 6.0.3'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]


# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # gema para ver los correos electronicos sin enviarlos
  gem "letter_opener"

  # gemas para hacer deploy
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger', '>= 0.1.1'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  
end


gem "draper", "~> 4.0"

gem "pg_search", "~> 2.3"

#Gemas para generar pdf produccion
# graficar
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary', '0.12.3.1'
gem 'chartkick', '~> 5.0', '>= 5.0.2'

#gem 'wicked_pdf', '~> 2.1.0'
#gem 'chartkick', '3.4.2'
#gem 'wkhtmltopdf-binary-edge', '~> 0.12.6.0'


# Gema para traducir las fechas
gem 'rails-i18n'

# Gema para paginar
gem 'will_paginate', '~> 4.0'
gem 'bootstrap-will_paginate'

#gemas para crear archivos xls
gem 'rubyzip', '>= 1.2.1'
gem 'caxlsx'
gem 'caxlsx_rails'

#gemas para ordenar y paginar databables
gem 'ransack'
gem 'pagy'


