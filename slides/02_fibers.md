!SLIDE subsection
# Fibers

!SLIDE bullets
# Fibers

 - Fibers are primitives for implementing **light weight** cooperative
   concurrency in Ruby. Basically they are a means of creating code blocks that
   can be paused and resumed, much **like threads**. The main difference is that
   they are never preempted and that the **scheduling must be done by the
   programmer** and not the VM.

   \- [Ruby Docs](http://ruby-doc.org/core-1.9/classes/Fiber.html)

<!-- New in Ruby 1.9 -->

!SLIDE smaller
# `Fiber.resume`

    @@@ ruby
    f = Fiber.new do
      puts 'Oh, hi!'
    end

    f.resume

    # Oh, hi!

!SLIDE smaller
# `Fiber.resume`

    @@@ ruby
    f = Fiber.new do
      # Fibers have full control.
      (0..100_000).each do |i|
        puts "Blocking :( #{ i }"
      end
    end

    f.resume
    puts "It's about time!"

    # Blocking :( 0
    # Blocking :( 1
    # Blocking :( 2
    # ...
    # Blocking :( 100000
    # It's about time!

<!-- Demonstrating manual scheduling -->


!SLIDE smaller
# `Fiber.yield`

    @@@ ruby
    f = Fiber.new do
      puts 'Starting fiber'
      Fiber.yield

      (0..100_000).each do |i|
        puts "Blocking :( #{ i }"
      end
    end

    f.resume
    puts "That was quick!"
    # Starting fiber
    # That was quick!

    f.resume
    puts "It's about time!"
    # Blocking :( 0
    # ...
    # Blocking :( 100000
    # It's about time!

    f.resume
    # FiberError: dead fiber called


!SLIDE smaller
# `Fiber.yield`

    @@@ ruby
    f = Fiber.new do
      i = 0
      while
        i = i + 1
        Fiber.yield(i) if i % 5 == 0
      end
    end

    f.resume # => 5
    f.resume # => 10
    f.resume # => 15
    f.resume # => 20

<!--
  Return value of #resume is the arguments passed to #yield or return value of
  the block.
-->


!SLIDE smaller
# `Fiber.yield`

    @@@ ruby
    Fiber.yield
    # FiberError: can't yield from root fiber

!SLIDE smaller
# `Fiber.current`

    @@@ ruby
    require 'fiber'

    f = Fiber.new do
      Fiber.current == f # => true
    end

    f.resume

!SLIDE smaller
# Fibers `<3` Events

    @@@ ruby
    EM.run do
      worker = Fiber.new do
        f = Fiber.current
        http = EM::HttpRequest.new('http://api.cld.me/9KXp').
                  get(:head => { 'Accept' => 'application/json' })

        http.callback { f.resume }
        http.errback  { f.resume }

        Fiber.yield
        puts http.response

        EM.stop
      end

      worker.resume
    end

!SLIDE smaller
# Abstractions FTW

    @@@ ruby
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
        get_drop '9KXp' # => {"content_url": ...
        get_drop '5kXC' # => {"content_url": ...

        EM.stop
      end.resume
    end

!SLIDE smaller
# em-synchrony

    @@@ ruby
    require 'em-synchrony'
    require 'em-synchrony/em-http'

    def get_drop(slug)
      http = EM::HttpRequest.new("http://api.cld.me/#{ slug }").
               get(:head => { 'Accept' => 'application/json' })

      http.response
    end

    EM.synchrony do
      get_drop '9KXp' # => {"content_url": ...
      get_drop '5kXC' # => {"content_url": ...

      EM.stop
    end

    puts 'reactor stopped'

!SLIDE smaller
# em-synchrony

    @@@ ruby
    # Transforms this...
    def get_drop(slug)
      f = Fiber.current
      http = EM::HttpRequest.new("http://api.cld.me/#{ slug }").
               get(:head => { 'Accept' => 'application/json' })

      http.callback { f.resume }
      http.errback  { f.resume }

      Fiber.yield
      http.response
    end

    # into this.
    def get_drop(slug)
      http = EM::HttpRequest.new("http://api.cld.me/#{ slug }").
               get(:head => { 'Accept' => 'application/json' })

      http.response
    end

!SLIDE smaller
# em-synchrony

    @@@ ruby
    # Transforms this...
    EM.run do
      Fiber.new do
        get_drop '9KXp' # => {"content_url": ...
        get_drop '5kXC' # => {"content_url": ...

        EM.stop
      end.resume
    end

    # into this.
    EM.synchrony do
      get_drop '9KXp' # => {"content_url": ...
      get_drop '5kXC' # => {"content_url": ...

      EM.stop
    end
