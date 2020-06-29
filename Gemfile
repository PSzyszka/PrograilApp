# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'bootstrap', '~> 4.5.0'
gem 'bootstrap-sass'
gem 'devise'
gem 'haml-rails'
gem 'haml_lint', require: false
gem 'httparty'
gem 'image_optim', '~> 0.26'
gem 'image_optim_pack'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'nokogiri'
gem 'oga'
gem 'omniauth-facebook'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.3'
gem 'sass-rails', '>= 6'
gem 'sassc-rails', '>= 2.1.0'
gem 'sidekiq'
gem 'slack-notifier'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'webpacker', '~> 4.0'
gem 'wombat'

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'rubocop', '~> 0.85.1', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'letter_opener'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'database_cleaner-active_record'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'vcr'
  gem 'webdrivers'
  gem 'webmock'
end
