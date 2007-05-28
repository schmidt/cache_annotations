require 'rubygems'
require 'cache_annotations'

class Example
  def self.show(title)
    puts
    puts title
    Timeout::timeout(10) do
      self.pp_fib(10)
      self.pp_fib(100)
    end
  rescue Timeout::Error
    puts "..."
    puts "Execution aborted after 10 seconds. This is to heavy."
  end

  def self.pp_fib(number)
      print "Fibonacci.compute(#{number}) = "
      t = self.timed { print Fibonacci.compute(number) } 
      puts "   # => #{t}s"
  end

  def self.timed
    t1 = Time.now
    yield
    Time.now - t1
  end
end

##############################################################################
##############################################################################

class Fibonacci
  module ClassMethods
    def compute(number)
      if number < 0
        raise ArgumentError.new("Fibonacci is not defined for numbers < 0")
      elsif number < 2
        number
      else
        Fibonacci.compute(number - 2) + Fibonacci.compute(number - 1)
      end
    end
  end
  self.extend(ClassMethods)
end

Example.show("Uncached Version")

##############################################################################
##############################################################################

class Fibonacci
  module ClassMethods
    include CacheAnnotation
    
    cached :in => :@fibonacci_cache
    def compute(number)
      if number < 0
        raise ArgumentError.new("Fibonacci is not defined for numbers < 0")
      elsif number < 2
        number
      else
        Fibonacci.compute(number - 2) + Fibonacci.compute(number - 1)
      end
    end
  end
  self.extend(ClassMethods)
end

Example.show("Cached Version")
