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


!SLIDE small
# Don't Block the Reactor!

    @@@ ruby
    while reactor_running?
        expired_timers.each { |timer| timer.process }
        new_network_io.each { |io| io.process }
    end

<!--
  Anything called by the reactor blocks the reactor.

  1. No sleeping
  2. No long loops
  3. No blocking I/O
  4. No polling

  These are all possible but should be implemented using EM's methods.
-->


!SLIDE small
# EM.system

    @@@ ruby
    EM.system('ls') do |output, status|
        puts output if status.exitstatus == 0
    end

<!-- Shell out without blocking. -->

!SLIDE small
# EM.popen

    @@@ ruby
    EM.popen 'ls', LsHandler

<!--
   - Lower level API used by EM.system
   - Streams stdout to the handler
   - TODO: Write LsHandler
-->




!SLIDE bullets smaller
# References

 - [Asynchrony](http://en.wikipedia.org/wiki/Asynchrony)
 - [Actor model](http://en.wikipedia.org/wiki/Actor_model)
 - [Concurrent computation](http://en.wikipedia.org/wiki/Concurrent_computation)
 - [EventMachine: scalable non-blocking i/o in ruby](http://timetobleed.com/eventmachine-scalable-non-blocking-io-in-ruby/)
 - [MiniMagick](https://github.com/probablycorey/mini_magick)
 - [EventedMagick](https://github.com/mperham/evented/tree/master/evented_magick)
