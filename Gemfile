source 'https://rubygems.org'
ruby '1.9.3'

# -------------------------------------------------------------- BASE RAILS GEMS
gem 'rails', '4.0.0'
gem 'sqlite3'
gem 'mysql2', '~>0.3.12b4'
# gem 'turbolinks'

gem "therubyracer", :require => 'v8'

# ------------------------------------------------------------ APP SPECIFIC GEMS
gem 'turbolinks'
gem 'figaro'

gem 'will_paginate', '~> 3.0.3'

# for background processing
# gem 'sidekiq'
# gem 'sinatra', :require => false
# gem 'slim'

# cron tasks
# gem 'whenever', :require => false
gem 'rest-client'

# --------------------------------------------------------------------------- js
gem 'jbuilder', '~> 1.2'
gem 'jquery-rails'

# -------------------------------------------------------------------- rendering
gem 'haml-rails'
gem 'less-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

# ----------------------------------------------------------------- view helpers
# gem 'twitter-bootstrap-rails'
# gem 'sass-rails', '>= 3.2'
gem 'bootstrap-sass', '~> 3.0.2.0'
gem 'simple_form', '>= 3.0.1'
gem 'will_paginate-bootstrap', '>= 1.0.0'
gem 'bootstrap-colorpicker-rails'

# ----------------------------------------------------------------- devel / test
group :development do
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller' #, :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'html2haml'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'hub', :require=>nil
  gem 'quiet_assets'
  gem 'rails_layout'
end

group :development, :test do
  gem 'factory_girl_rails'
end

group :test do
  gem 'capybara'
  gem 'minitest-spec-rails'
  gem 'minitest-wscolor'
end
