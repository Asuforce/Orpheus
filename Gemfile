source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails', '4.2.2'
gem 'bcrypt', '3.1.7'
gem 'faker', '1.4.2'
gem 'carrierwave', '0.10.0'
gem 'mini_magick', '3.8.0'
gem 'carrierwave-aws', '1.0.1'
gem 'will_paginate', '3.0.7'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'bootstrap-sass', '3.2.0.0'
gem 'sass-rails', '5.0.2'
gem 'uglifier', '2.5.3'
gem 'coffee-rails', '4.1.0'
gem 'jquery-rails', '4.0.3'
gem 'turbolinks', '2.3.0'
gem 'jbuilder', '2.2.3'
gem 'sdoc', '0.4.0', group: :doc
gem 'sqlite3', '1.3.9', group: :development

group :development do
  gem 'capistrano', '3.6.1'
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn'
  gem 'net-ssh', '>=4.0.0.beta3'
  gem 'bcrypt_pbkdf'
  gem 'rbnacl-libsodium'
end

group :development, :test do
  gem 'byebug', '3.4.0'
  gem 'web-console', '2.0.0.beta3'
  gem 'spring', '1.1.3'
  gem 'dotenv-rails', '2.1.1'
end

group :test, :production do
  gem 'mysql2', '0.3.21'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace', '0.1.3'
  gem 'guard-minitest', '2.3.1'
  gem 'json_expressions', '0.8.3'
end

group :production do
  gem 'rails_12factor', '0.0.2'
  gem 'unicorn', '5.1.0'
end
