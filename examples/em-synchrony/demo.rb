require 'em-synchrony'
require 'em-synchrony/em-http'

def get_drop(slug)
  EM::HttpRequest.new("http://api.cld.me/#{ slug }").
    get(:head => { 'Accept' => 'application/json' }).
    response
end

EM.synchrony do
  Fiber.new do
    puts 'Retrieving 9KXp...'
    puts get_drop('9KXp')

    puts 'Retrieving 5kXC...'
    puts get_drop('5kXC')

    EM.stop
  end.resume
end

puts 'done'
