require 'bundler/setup'
Bundler.require

$stocks = {CAKE: 100.0, QQ: 50.0, LOL: 85.0}
$connections = []
set server: 'thin'

Thread.new do
  while true
    sleep rand(2)
    k = $stocks.keys[rand($stocks.length)]
    $stocks[k] += 5 - rand(10)
    $connections.each {|c| c << "event: #{k}\ndata: #{$stocks[k]}\n\n"}
  end
end

get '/' do
  erb :index, locals: { stocks: $stocks }
end

get '/stream', provides: 'text/event-stream' do
  stream :keep_open do |out|
    $connections << out
    out.callback { $connections.delete(out) }
  end
end
