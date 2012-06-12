require 'bundler/setup'
Bundler.require
Thread.abort_on_exception = true

set server: 'thin',
    conns: [],
    public_folder: File.dirname(__FILE__) + '/public',
    stocks: {AAPL: 500.0, MSFT: 30.0, GOOG: 600.0}

get '/' do
  erb :index, locals: { stocks: settings.stocks }
end

get '/stocks', provides: 'text/event-stream' do
  stream :keep_open do |out|
    settings.conns.push(out)
    out.callback { settings.conns.delete(out) }
  end
end

def notify(data, name=nil)
  settings.conns.each do |out|
    out << "event: #{name}\n" if name
    out << "data: #{data}\n\n"
  end
end

Thread.new do
  while true
    sleep rand(2)
    symbol = settings.stocks.keys.sample
    settings.stocks[symbol] += rand(-5..5)
    notify(settings.stocks[symbol], symbol)
    notify("#{rand(2) == 1 ? 'Buy' : 'Sell'} Now!")
  end
end
