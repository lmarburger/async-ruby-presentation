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
# Working With Fibers

    @@@ ruby
    fiber = Fiber.new do
      puts 'Starting fiber!'
      Fiber.yield 1
      2
    end

    fiber.resume
    # Starting fiber!
    # => 1 

    fiber.resume
    # => 2 

    fiber.resume
    # FiberError: dead fiber called

!SLIDE smaller
# Working With Fibers

    @@@ ruby
    fiber = Fiber.new do
      puts 'Starting fiber!'
      Fiber.yield 1
      2
    end

    fiber.resume
    # Starting fiber!
    # => 1 

    fiber.resume
    # => 2 

    fiber.resume
    # FiberError: dead fiber called
