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
  property  :path,        String, length: 2096, unique_index: true, required: true
  property  :created_at,  DateTime
end
DataMapper.finalize.auto_upgrade!

get '/p/:permalink' do
  @slide = Slide.get(Bijective.decode(params[:permalink]))
end

get '*' do
  path = params[:splat].first
  slide = Slide.first_or_create(path: path)
  redirect to("/p/#{Bijective.encode(slide.id)}")
end
