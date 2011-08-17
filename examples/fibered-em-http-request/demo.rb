require 'em-http-request'
require 'fiber'

EM.run do
  puts '1. reactor started'

  worker = Fiber.new do
    f = Fiber.current
    http = EM::HttpRequest.new('http://api.cld.me/9KXp').
             get(:head => { 'Accept' => 'application/json' })

    http.callback { f.resume }
    http.errback  { f.resume }

    puts '3. worker yielded'
    Fiber.yield

    puts '5. worker complete'
    puts http.response

    EM.stop
  end

  puts '2. starting worker'
  worker.resume

  puts '4. reactor regained control'
end

puts '6. reactor stopped'

# Output
#   1. reactor started
#   2. starting worker
#   3. worker yielded
#   4. reactor regained control
#   5. worker complete
#   {"content_url":"http://cl.ly/9KXp/cover.jpg","href":"http://my.cl.ly/items/8462162","name":"cover.jpg","redirect_url":null,"created_at":"2011-08-16T18:49:33Z","updated_at":"2011-08-16T18:49:49Z","private":false,"deleted_at":null,"url":"http://cl.ly/9KXp","view_counter":0,"remote_url":"http://f.cl.ly/items/2m1n1x2W132C0C0s2C2X/cover.jpg","icon":"http://my.cl.ly/images/new/item-types/image.png","id":8462162,"subscribed":true,"thumbnail_url":"http://thumbs.cl.ly/9KXp","source":"Cloud/1.5.1 CFNetwork/520.0.13 Darwin/11.0.0 (x86_64) (MacBookPro5%2C5)","item_type":"image"}
#   6. reactor stopped


# via http://www.igvita.com/2010/03/22/untangling-evented-code-with-ruby-fibers/
def get_drop(slug)
  f = Fiber.current
  http = EM::HttpRequest.new("http://api.cld.me/#{ slug }").
           get(:head => { 'Accept' => 'application/json' })

  http.callback { f.resume }
  http.errback  { f.resume }

  Fiber.yield
  http.response
end

EM.run do
  Fiber.new do
    puts 'Retrieving 9KXp...'
    puts get_drop('9KXp')

    puts 'Retrieving 5kXC...'
    puts get_drop('5kXC')

    EM.stop
  end.resume
end

puts 'done'


# Output
#   Retrieving 9KXp...
#   {"content_url":"http://cl.ly/9KXp/cover.jpg","href":"http://my.cl.ly/items/8462162","name":"cover.jpg","redirect_url":null,"created_at":"2011-08-16T18:49:33Z","updated_at":"2011-08-16T18:49:49Z","private":false,"deleted_at":null,"url":"http://cl.ly/9KXp","view_counter":0,"remote_url":"http://f.cl.ly/items/2m1n1x2W132C0C0s2C2X/cover.jpg","icon":"http://my.cl.ly/images/new/item-types/image.png","id":8462162,"subscribed":true,"thumbnail_url":"http://thumbs.cl.ly/9KXp","source":"Cloud/1.5.1 CFNetwork/520.0.13 Darwin/11.0.0 (x86_64) (MacBookPro5%2C5)","item_type":"image"}
#   Retrieving 5kXC...
#   {"content_url":"http://cl.ly/5kXC","href":"http://my.cl.ly/items/4268562","name":"http://getcloudapp.com/download","redirect_url":"http://getcloudapp.com/download","created_at":"2011-04-04T17:10:14Z","updated_at":"2011-04-12T12:26:24Z","private":false,"deleted_at":null,"url":"http://cl.ly/5kXC","view_counter":55,"remote_url":null,"icon":"http://my.cl.ly/images/new/item-types/bookmark.png","id":4268562,"subscribed":true,"source":null,"item_type":"bookmark"}
#   done
