require 'rake'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "cache_annotations"
    gemspec.summary = "Annotation-like API to configure method caching"
    gemspec.description = "Cache Annotations provides an Annotation like " +
      "interface to mark methods as functional. These are then cached " +
      "automagically. This leads to cleaner code without performance " +
      "implications." 
    gemspec.email = "ruby@schmidtwisser.de"
    gemspec.homepage = "http://github.com/schmidt/cache_annotations"
    gemspec.authors = ["Gregor Schmidt"]

    gemspec.add_development_dependency('rake')
    gemspec.add_development_dependency('jeweler', '>= 1.4.0')
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

desc "Run all tests"
task :test do 
  require 'rake/runtest'
  Rake.run_tests 'test/**/test_*.rb'
end

desc 'Generate documentation for the literate_maruku gem.'
Rake::RDocTask.new(:doc) do |doc|
  doc.rdoc_dir = 'doc'
  doc.title = 'cache_annotations'
  doc.options << '--line-numbers' << '--inline-source'
  doc.rdoc_files.include('README.rdoc')
  doc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test
