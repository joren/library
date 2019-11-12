source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.3.1'
gem 'coffee-rails', '~> 5.0.0'
gem 'epub-parser', '~> 0.4.0'
gem 'goodreads'
gem 'jquery-rails', '~> 4.3', '>= 4.3.1'
gem 'kaminari', '~> 1.1', '>= 1.1.1'
gem 'mini_magick', '~> 4.8'
gem 'mini_racer', '~> 0.2.4'
gem 'puma', '~> 4.0'
gem 'rails', '~> 5.2.3'
gem 'sass-rails', '~> 5.0'
gem 'slim', '~> 4.0', '>= 4.0.1'
gem 'slim-rails', '~> 3.2'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry', '~> 0.12'
  gem 'letter_opener', '~> 1.7'
  gem 'pg', '~> 1.1'
end

group :development do
  gem 'capistrano', '~> 3.11', '>= 3.11.2'
  gem "capistrano-rails", "~> 1.3", require: false
  gem 'capistrano-chruby'
  gem 'capistrano-bundler', '~> 1.6'
  gem 'capistrano-passenger'

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group "production" do
  gem 'mysql2', '~> 0.5.2'
end
