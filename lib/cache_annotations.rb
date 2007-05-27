unless Object.const_defined?("CacheAnnotation")
require File.dirname(__FILE__) + '/cache_annotations/version'

module CacheAnnotation
  def self.included(klass) #:nodoc:
    if klass.methods.include? "method_added"
      class << klass 
        alias cache_annotation_saved_method_added method_added
      end
    else
      class << klass 
        define_method "cache_annotation_saved_method_added" do |a| end
      end
    end
    klass.extend(CacheAnnotation::ClassMethods)
  end

  module ClassMethods
    protected
    def cached(options = {})
      @annotated = options 
    end

    def method_added(method_name) #:nodoc:
      cache_annotation_saved_method_added(method_name)
      @annotated ||= false
      if @annotated
        options, @annotated = @annotated, nil
        cache_method(method_name, options)
      end
    end

    private
    def cache_method(method_name, options) #:nodoc:
      options = {
          :in => "@#{method_name}"
        }.merge!(options)

      case self.instance_method( method_name ).arity
      when 0
        self.class_eval %Q{
          alias_method("cache_annotation_saved_#{method_name}", method_name)
          def #{method_name}
            #{options[:in]} ||= 
                cache_annotation_saved_#{method_name}
          end
        }, __FILE__, __LINE__ 
      when 1
        self.class_eval %Q{
          alias_method("cache_annotation_saved_#{method_name}", method_name)
          def #{method_name}(arg0)
            #{options[:in]} ||= Hash.new
            #{options[:in]}[arg0] ||= 
                cache_annotation_saved_#{method_name}(arg0)
          end
        }, __FILE__, __LINE__ 
      else
        raise ArgumentError.new(
                    "unsupported number of arguments for a cached method")
      end
    end
  end
end 

end
