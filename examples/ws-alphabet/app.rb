require 'eventmachine'
require 'em-websocket'

@sockets = []
EventMachine.run do
  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 34589) do |socket|
    socket.onopen do
      @sockets << socket
    end
    socket.onmessage do |mess|
      @sockets.each {|s| s.send mess}
    end
    socket.onclose do
      @sockets.delete socket
    end
  end
end
