require 'em-http-request'
require 'yajl'

EventMachine.run do
  http = EventMachine::HttpRequest.new('http://api.cld.me/9KXp').
           get(:head => { 'Accept' => 'application/json' })

  http.errback do
    puts 'Failed!'
    EM.stop
  end

  http.callback do
    p Yajl::Parser.parse(http.response)
    EM.stop
  end
end
