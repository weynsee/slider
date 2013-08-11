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

def four_oh_four
  status 404
  @panels, @title = ['404'], "404"
  slim :show
end

get '/p/:permalink' do
  slide = Slide.find_by_permalink(params[:permalink]) if params[:permalink] =~ /\A[a-zA-Z]+\Z/
  if slide
    @panels = slide.panels
    @title = @panels.join(' ')
    slim :show
  else
    four_oh_four
  end
end

get '*' do
  path = params[:splat].first
  if path == '/' || path.strip == ''
    four_oh_four
  else
    slide = Slide.first_or_create(path: path)
    redirect to("/p/#{slide.permalink}")
  end
end

__END__

@@ show
doctype html
html lang="en"
  head
    meta charset="utf-8"
    title = @title
    meta name="apple-mobile-web-app-capable" content="yes"
		meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"
		meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"
    link rel="stylesheet" href="http://cdn.jsdelivr.net/reveal.js/2.4.0/css/reveal.min.css"
    link rel="stylesheet" href="http://cdn.jsdelivr.net/reveal.js/2.4.0/css/theme/simple.css"
    /[if lt IE 9]
      script src="http://cdn.jsdelivr.net/reveal.js/2.4.0/lib/js/html5shiv.js"

  body
    div.reveal
      div.slides
        - for panel in @panels
          section
            h1
              strong = panel
    script src="//cdn.jsdelivr.net/reveal.js/2.4.0/lib/js/head.min.js"
    script src="http:////cdn.jsdelivr.net/reveal.js/2.4.0/js/reveal.min.js"
    javascript:
      Reveal.initialize({ progress: false, transition: 'linear' });
