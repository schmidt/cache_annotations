require File.dirname(__FILE__) + '/test_helper.rb'

class A
  include CacheAnnotation

  def a
  end

  cached
  def b
    "b"
  end

  cached :in => "@c_cache"
  def c
    "c"
  end

  cached
  def d(arg0)
    arg0.to_s 
  end

  cached :in => "@e_cache"
  def e(arg0)
    arg0.to_s 
  end
end

class TestCacheAnnotation < Test::Unit::TestCase

  def setup
    @a = A.new
  end

  def test_basics
    self.methods.select { |name| name =~ /^basic_.*/ }.each do | name |
      setup
      self.send name
    end
  end

  def test_meta_properties
    assert_nothing_raised "including CacheAnnotation twice fails" do
      class << A
        include CacheAnnotation
      end
    end
    test_basics
    assert_nothing_raised "including CacheAnnotation twice fails" do
      class << A
        cached
        def a
          "a"
        end
      end
    end
    test_basics
  end

  def basic_simple_cached_method
    assert_equal "b", @a.b, "First access to cached method failed"
    assert_equal "b", @a.b, "Second access to cached method failed"
    assert_equal "b", @a.b, "Repeated access to cached method failed"
    assert_equal "b", @a.instance_variable_get(:@b), "Value was not " +
                                        "stored in the right instance variable"
    @a.instance_variable_set(:@b, "b2")
    assert_equal "b2", @a.b, "Instance variable not used for cache"
  end

  def basic_simple_cached_method_with_costum_cache
    assert_equal "c", @a.c, "First access to cached method failed"
    assert_equal "c", @a.c, "Second access to cached method failed"
    assert_equal "c", @a.c, "Repeated access to cached method failed"
    assert_equal "c", @a.instance_variable_get(:@c_cache), "Value was not " +
                                        "stored in the right instance variable"
    @a.instance_variable_set(:@c_cache, "c2")
    assert_equal "c2", @a.c, "Instance variable not used for cache"
  end

  def basic_cached_method
    assert_equal "d", @a.d("d"), "First access to cached method failed"
    assert_equal "d", @a.d("d"), "Second access to cached method failed"
    assert_equal "d", @a.d("d"), "Repeated access to cached method failed"
    assert_equal "d", @a.instance_variable_get(:@d)["d"], "Value was not " +
                                        "stored in the right instance variable"

    assert_equal "d1", @a.d("d1"), "First access to cached method failed"
    assert_equal "d1", @a.d("d1"), "Second access to cached method failed"
    assert_equal "d1", @a.d("d1"), "Repeated access to cached method failed"
    assert_equal "d1", @a.instance_variable_get(:@d)["d1"], "Value was not " +
                                        "stored in the right instance variable"

    @a.instance_variable_get(:@d)["d"] = "d2"
    assert_equal "d2", @a.d("d"), "Instance variable not used for cache"
  end

  def basic_cached_method_with_costum_cache
    assert_equal "e", @a.e("e"), "First access to cached method failed"
    assert_equal "e", @a.e("e"), "Second access to cached method failed"
    assert_equal "e", @a.e("e"), "Repeated access to cached method failed"
    assert_equal "e", @a.instance_variable_get(:@e_cache)["e"], "Value " +
                              "was not stored in the right instance variable"

    assert_equal "e1", @a.e("e1"), "First access to cached method failed"
    assert_equal "e1", @a.e("e1"), "Second access to cached method failed"
    assert_equal "e1", @a.e("e1"), "Repeated access to cached method failed"
    assert_equal "e1", @a.instance_variable_get(:@e_cache)["e1"], "Value " +
                              "was not stored in the right instance variable"

    @a.instance_variable_get(:@e_cache)["e"] = "e2"
    assert_equal "e2", @a.e("e"), "Instance variable not used for cache"
  end
end

class B 
  module ClassMethods
    include CacheAnnotation

    def a
      "a"
    end

    cached
    def b
      "b"
    end

    cached :in => "@c_cache"
    def c
      "c"
    end

    cached
    def d(arg0)
      arg0.to_s 
    end

    cached :in => "@e_cache"
    def e(arg0)
      arg0.to_s 
    end
  end
  self.extend(ClassMethods)
end

class TestCacheAnnotationOnClassSide < Test::Unit::TestCase

  def test_basics
    self.methods.select { |name| name =~ /^basic_.*/ }.each do | name |
      setup
      self.send name
    end
  end

  def basic_simple_cached_method
    assert_equal "b", B.b, "First access to cached method failed"
    assert_equal "b", B.b, "Second access to cached method failed"
    assert_equal "b", B.b, "Repeated access to cached method failed"
    assert_equal "b", B.instance_variable_get(:@b), "Value was not " +
                                        "stored in the right instance variable"
    B.instance_variable_set(:@b, "b2")
    assert_equal "b2", B.b, "Instance variable not used for cache"
  end

  def basic_simple_cached_method_with_costum_cache
    assert_equal "c", B.c, "First access to cached method failed"
    assert_equal "c", B.c, "Second access to cached method failed"
    assert_equal "c", B.c, "Repeated access to cached method failed"
    assert_equal "c", B.instance_variable_get(:@c_cache), "Value was not " +
                                        "stored in the right instance variable"
    B.instance_variable_set(:@c_cache, "c2")
    assert_equal "c2", B.c, "Instance variable not used for cache"
  end

  def basic_cached_method
    assert_equal "d", B.d("d"), "First access to cached method failed"
    assert_equal "d", B.d("d"), "Second access to cached method failed"
    assert_equal "d", B.d("d"), "Repeated access to cached method failed"
    assert_equal "d", B.instance_variable_get(:@d)["d"], "Value was not " +
                                        "stored in the right instance variable"

    assert_equal "d1", B.d("d1"), "First access to cached method failed"
    assert_equal "d1", B.d("d1"), "Second access to cached method failed"
    assert_equal "d1", B.d("d1"), "Repeated access to cached method failed"
    assert_equal "d1", B.instance_variable_get(:@d)["d1"], "Value was not " +
                                        "stored in the right instance variable"

    B.instance_variable_get(:@d)["d"] = "d2"
    assert_equal "d2", B.d("d"), "Instance variable not used for cache"
  end

  def basic_cached_method_with_costum_cache
    assert_equal "e", B.e("e"), "First access to cached method failed"
    assert_equal "e", B.e("e"), "Second access to cached method failed"
    assert_equal "e", B.e("e"), "Repeated access to cached method failed"
    assert_equal "e", B.instance_variable_get(:@e_cache)["e"], "Value " +
                              "was not stored in the right instance variable"

    assert_equal "e1", B.e("e1"), "First access to cached method failed"
    assert_equal "e1", B.e("e1"), "Second access to cached method failed"
    assert_equal "e1", B.e("e1"), "Repeated access to cached method failed"
    assert_equal "e1", B.instance_variable_get(:@e_cache)["e1"], "Value " +
                              "was not stored in the right instance variable"

    B.instance_variable_get(:@e_cache)["e"] = "e2"
    assert_equal "e2", B.e("e"), "Instance variable not used for cache"
  end
end
