ENV['masteruser'] ||= 'master'
ENV['masterpass'] ||= 'pass'
require 'bundler/setup'
Bundler.require

set server: 'thin',
    connections: []

get '/' do
  erb :index, locals: { master: false }
end

get '/master' do
  protected!
  erb :index, locals: { master: true }
end

post '/navigate/:slide' do |slide|
  protected!
  settings.connections.each {|c| c << "data: #{slide}\n\n" }
  204
end

get '/view', provides: 'text/event-stream' do
  stream :keep_open do |out|
    settings.connections << out
    out.callback { settings.connections.delete(out) }
  end
end

helpers do
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ENV['masteruser'], ENV['masterpass']]
  end
end
