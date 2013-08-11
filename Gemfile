source 'https://rubygems.org'
ruby '2.0.0'

gem 'puma'
gem 'sinatra'

gem 'dm-core'
gem 'dm-timestamps'
gem 'dm-migrations'

gem 'slim'

group :test do
  gem 'rspec'
  gem 'rack-test'
end

group :development, :test do
  gem 'dm-sqlite-adapter'
  gem 'sqlite3'
end

gem 'pg', group: :production
