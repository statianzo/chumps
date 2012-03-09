require 'bundler/setup'
Bundler.require

set server: 'thin',
    connections: []

get '/' do
  erb :index, locals: { master: !!params['master'] }
end

post '/navigate/:slide' do |slide|
  settings.connections.each {|c| c << "data: #{slide}\n\n" }
  204
end

get '/view', provides: 'text/event-stream' do
  stream :keep_open do |out|
    settings.connections << out
    out.callback { settings.connections.delete(out) }
  end
end
