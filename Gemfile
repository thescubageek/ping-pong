source 'https://rubygems.org'

ruby '2.2.0'
gem 'rails', '4.1.8'
gem 'pg'

gem "bootstrap-sass", "~> 2.1.0.1"
gem "bourbon"

gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

gem 'underscore-string-rails'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'spring',        group: :development

gem 'active_model_serializers', '0.9.2'

gem "quiet_assets"

gem "heroku_resque_autoscaler"

gem 'trueskill', :git => 'git://github.com/thescubageek/trueskill', branch: 'fix-bayesian'
#gem 'trueskill', :path => '/Users/stevecraig/g5gems/trueskill'

group :development do
  #gem "better_errors"
end

group :development, :test do
  gem "dotenv-rails", "~> 0.11.1"
  gem "pry"
  gem 'pry-remote'
  gem 'bullet'
  gem "sqlite3"
  gem "foreman"
end


group :test do
  gem 'resque_spec'
  gem "timecop"
  gem "rspec-rails"
  gem "rspec-its"
  gem "shoulda-matchers"
  gem 'capybara'
end

gem 'rails_12factor', group: :production


