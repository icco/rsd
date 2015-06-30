require "rubygems"
require "bundler"
Bundler.require(:default, ENV["RACK_ENV"] || :development)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

configure do
  RACK_ENV = (ENV['RACK_ENV'] || :development).to_sym
  connections = {
    :development => "postgres://localhost/rcdir",
    :test => "postgres://postgres@localhost/rcdir_test",
    :production => ENV['DATABASE_URL']
  }

  url = URI(connections[RACK_ENV])
  options = {
    :adapter => url.scheme,
    :host => url.host,
    :port => url.port,
    :database => url.path[1..-1],
    :username => url.user,
    :password => url.password
  }

  case url.scheme
  when "sqlite"
    options[:adapter] = "sqlite3"
    options[:database] = url.host + url.path
  when "postgres"
    options[:adapter] = "postgresql"
  end
  set :database, options

  use Rack::Session::Cookie, :key => 'rack.session',
    :path => '/',
    :expire_after => 86400, # 1 day
    :secret => ENV['SESSION_SECRET'] || '*&(^B234'

  use OmniAuth::Builder do
    provider :recurse_center, ENV['RC_ID'], ENV['RC_SECRET']
  end
end

get "/" do
  if session[:uid]
    @user = User.where(id: session[:uid]).first

    if @user.nil?
      error 500
    else
      erb :index
    end
  else
    redirect "/auth/recurse_center"
  end
end

get "/user/:id" do
  @user = User.where(id: params[:id]).first

  if @user.nil?
    error 404
  else
    erb :user
  end
end

get "/service/:name" do
  @service = Service.where(name: params[:name]).first

  if @service.nil?
    error 404
  else
    erb :service
  end
end

get "/add" do
  erb :add
end

post "/add" do
  redirect "/"
end

%w(get post).each do |method|
  send(method, "/auth/:provider/callback") do
    # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
    session[:uid] = env['omniauth.auth']['uid']
    session[:token] = env['omniauth.auth']['credentials']['token']

    u = User.find_or_create_by(id: session[:uid])
    u.name = env['omniauth.auth']['info']['name']
    u.image = env['omniauth.auth']['info']['image']
    u.batch = env['omniauth.auth']['info']['batch']['name']
    u.save

    redirect "/"
  end
end

get "/logout" do
  session[:uid] = nil
  redirect "/"
end

error 400..510 do
  @code = response.status
  erb :error
end
