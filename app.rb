require 'rubygems'
require 'bundler/setup'
require './lib/bijective'

env = ENV['RACK_ENV'] || 'development'
env = env.to_sym
Bundler.require(:default, env)

enable :inline_templates

DataMapper.setup(:default, "sqlite3::memory:")
class Slide
  include DataMapper::Resource
  property  :id,          Serial
  property  :path,        String, length: 2096, unique_index: true, required: true
  property  :created_at,  DateTime

  def permalink
    Bijective.encode(id)
  end

  def self.find_by_permalink(permalink)
    get(Bijective.decode(permalink))
  end

  def panels
    path.split('/').reject { |component| component.nil? || component.strip == "" }
  end
end
DataMapper.finalize.auto_upgrade!

get '/p/:permalink' do
  slide = Slide.find_by_permalink(params[:permalink])
  @panels = slide.panels
  slim :show
end

get '*' do
  path = params[:splat].first
  slide = Slide.first_or_create(path: path)
  redirect to("/p/#{slide.permalink}")
end

helpers do
  def title
    @panels.join(' ')
  end
end

__END__

@@ show
doctype html
html lang="en"
  head
    meta charset="utf-8"
    title = title
  body
