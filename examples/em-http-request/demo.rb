require 'em-http-request'

EventMachine.run do
  http = EventMachine::HttpRequest.new('http://api.cld.me/9KXp').
           get(:head => { 'Accept' => 'application/json' })

  http.errback do
    puts 'Failed!'
    EM.stop
  end

  http.callback do
    puts http.response
    EM.stop
  end
end
