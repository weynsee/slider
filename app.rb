require 'rubygems'
require 'bundler/setup'
require './lib/bijective'

env = ENV['RACK_ENV'] || 'development'
env = env.to_sym
Bundler.require(:default, env)

DataMapper.setup(:default, "sqlite3::memory:")
class Slide
  include DataMapper::Resource
  property  :id,          Serial
  property  :path,        String, length: 255
  property  :created_at,  DateTime
end
DataMapper.finalize.auto_upgrade!

get '/' do
  "Hello World"
end
