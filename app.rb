require 'bundler'
Bundler.require
require 'active_support/time'
require 'active_support/inflector'
require './lib/assets'
require './lib/facebook'
require './lib/text'

Time.zone = "Europe/Berlin"
I18n.load_path << File.join(File.dirname(__FILE__), 'config', 'locales.yml')
I18n.locale = :de

Sinatra.register Assets
Sinatra.register Text

module Settings
  def self.setup_development!
    setup_common!
    @redis = Redis.new
    @cache_ttl = 0
  end

  def self.setup_production!
    setup_common!
    uri = URI.parse(ENV["REDISTOGO_URL"])
    @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    @cache_ttl = 30 * 60
  end

  def self.setup_common!
    @facebook = Hash[*ENV["DATA_FACEBOOK"].split(",")]
    @google   = Hash[*ENV["DATA_GOOGLE"].split(",")]
    @site_url = "http://www.hundetraining-teamarbeit.de"
  end

  def self.redis
    @redis
  end

  def self.facebook
    @facebook
  end

  def self.google
    @google
  end

  def self.site_url
    @site_url
  end

  def self.cache_ttl
    @cache_ttl
  end  
end

set :public_folder, File.dirname(__FILE__) + '/public'
set :views,    File.dirname(__FILE__) + '/views'

configure :development do
  Settings.setup_development!
end

configure :production do
  Settings.setup_production!
end

not_found do
  haml :"404"
end

# Ein Kommentar
get '/' do
  posts = Facebook::Post.all
  haml :index, :locals => { :posts => posts }
end

get '/ueberuns/?' do
  page = Facebook::Page.load
  haml :about, :locals => { :page => page }
end

get '/ueberuns/estherfollmann' do
  haml :estherfollmann
end

get '/ueberuns/mirjambaeuerlein' do
  haml :mirjambaeuerlein
end

get '/kontakt' do
  haml :contact
end

get '/bilder/?' do
  albums = Facebook::Album.all
  haml :albums, :locals => { :albums => albums }
end

get '/bilder/:id/:name' do
  album = Facebook::Album.find(params[:id])
  haml :album, :locals => { :album => album }
end

get '/termine/?' do
  events = Facebook::Event.all
  haml :events, :locals => { :events => events }
end

get '/termine/:id/:name' do
  event = Facebook::Event.find(params[:id])
  haml :event, :locals => { :event => event }
end

get '/sitemap.xml' do
  haml :sitemap, :layout => false
end
