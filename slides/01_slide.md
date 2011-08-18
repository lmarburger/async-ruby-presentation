!SLIDE 
# Awesomely Audacious Adventures in Asynchrony

!SLIDE bullets
# Asynchronous Programming

 - In programming, asynchronous events are those **occurring independently** of
   the main program flow. Asynchronous actions are actions executed in a
   **non-blocking scheme**, allowing the main program flow to **continue
   processing**.

   \- [Wikipedia](http://en.wikipedia.org/wiki/Asynchrony)

!SLIDE bullets
# Asynchronous Programming

 - **Automatic parallelization** of a sequential program by a compiler is the
   holy grail of parallel computing. Despite decades of work by compiler
   researchers, automatic parallelization has had **only limited success**.

   \- [Wikipedia](http://en.wikipedia.org/wiki/Concurrent_computation)

<!-- Seems to be the goal of em-synchrony -->


!SLIDE bullets
# Asynchronous Techniques

 - Message queues
 - Threads
 - Actor model
 - Reactor pattern

<!--
   - Long connections
     - Web sockets
     - Jabber
   - Thubmaniling images
   - Consuming APIs
   - Query a database
   - Interacting with the filesystem
-->


!SLIDE subsection
# Meet the Reactor

!SLIDE smaller
# Meet the Reactor

    @@@ ruby
    # EM#run blocks until EM#stop is called
    EventMachine.run do
      puts 'Oh, hi!'
    end

    puts "You'll never see me"


!SLIDE smaller
# Meet the Reactor

    @@@ ruby
    # EM#run blocks until EM#stop is called
    EventMachine.run do
      puts 'Oh, hi!'
      EventMachine.stop
    end

    puts "Now you'll see me!"


!SLIDE smaller
# Don't Block the Reactor!

    @@@ ruby
    # The reactor can only do one thing at a time
    EM.run do
      while true do
        puts 'Blocking :('
      end

      puts 'Oh noes!'
    end


!SLIDE smaller
# Don't Block the Reactor!

    @@@ ruby
    EM.run do
      # The reactor can only do one thing at a time
      (0..100_000).each do |i|
        puts "Blocking :( #{ i }"
      end

      puts "It's about time!"
    end

    # Blocking :( 0
    # Blocking :( 1
    # Blocking :( 2
    # ...
    # Blocking :( 100000
    # It's about time!

<!--
  Anything called by the reactor blocks the reactor.

   1. No sleeping
   2. No long loops
   3. No blocking I/O
   4. No polling

  These are all possible but should be implemented using EM's methods.
-->

!SLIDE smaller
# Don't Block the Reactor!

    @@@ ruby
    EM.run do
      # Iterate over a collection without blocking!
      EM::Iterator.new(0..100_000).each do |i, iterator|
        puts "Not blocking! :) #{ i }"
        iterator.next
      end

      puts "I'm called first"
    end

    # I'm called first
    # Not blocking! :) 0
    # Not blocking! :) 1
    # Not blocking! :) 2
    # ...

<!--
  EM::Iterator also provides #map and #inject
  Optional concurrency argument
-->


!SLIDE smaller
# `EM.system`

    @@@ ruby
    EM.system('ls') do |output, status|
      puts output if status.exitstatus == 0
    end

    # Stream stdout to handler
    EM.popen 'ls', LsHandler

<!--
   - Shell out without blocking.
   - EM.popen is the lower level API used by EM.system
   - EM.popen streams stdout to the handler
-->


!SLIDE smaller
# `EM::HttpRequest`

    @@@ ruby
    require 'em-http-request'
    require 'yajl'

    EM.run do
      http = EM::HttpRequest.
               new('http://api.cld.me/9KXp').
               get(:head => { 'Accept' => 'application/json' })

      http.callback do
        puts Yajl::Parser.parse(http.response)
        EM.stop
      end

      http.errback do
        puts 'Failed!'
        EM.stop
      end
    end

<!--
   1. Start the reactor
   2. Create the request
   3. Attach handlers
   4. Handle response
   4. Stop the reactor
-->
