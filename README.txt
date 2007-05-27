With CacheAnnotation you may easily provide your methods with an often needed
caching. Suppose you are using the following piece of code:

  class A
    def a
      @a ||= "some heavy computing that should be done only once"
    end
  end

This could look so much better:

  class A
    include CacheAnnotation

    cached
    def a
      "some heavy computing that should be done only once"
    end
  end

Or even better for single argumented methods:

  class A
    def b(arg0)
      @b ||= {}
      @b[arg0] ||= "some heavy computing in respect to #{arg0} " + 
                   "that should be done only once"
    end
  end

vs.

  class A
    include CacheAnnotation

    cached
    def b(arg0)
      "some heavy computing in respect to #{arg0} " + 
      "that should be done only once"
    end
  end

Behind the scenes, CacheAnnotation replaces the method body with the caching
code. So the two versions are equal concerning behaviour and speed. If you
don't want CacheAnnotation to derive the instance variable's name from the 
method name, you may supply a custom one:

  class A
    include CacheAnnotation

    cached :in => :@b_cache
    def b(arg0)
      "some heavy computing in respect to #{arg0} " + 
      "that should be done only once"
    end
  end

If you want to use CacheAnnotation on the class side, you have to use a 
special technique to add these methods. It is described pretty good on 
http://www.dcmanges.com/blog/27

  class A
    module ClassMethods
      include CacheAnnotation

      cached
      def c
        "some heavy computing that should be done only once"
      end
    end
    self.extend(ClassMethods)
  end

