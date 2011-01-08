require 'rubygems'
require 'rake'

class FailedTestsException < Exception;end
class FailedCleanException < Exception;end

task :default => 'sampletest:all'

namespace :sampletest do
  current_dir = File.dirname(__FILE__)
  home_dir = ENV['HOME']
  iphone_sdk = ENV['IPHONE_SDK'] || "iphonesimulator3.1.3"

  desc "clean out the build directory"
  task :clean do
   clean_result = %x{xcodebuild clean -configuration Debug -sdk #{iphone_sdk}}
   print clean_result
   if clean_result.match(/error/i)
     puts "clean failed"
     throw FailedCleanException.new
   end
  end

  desc "build and run the tests"
  task :test do
   test_result = %x{xcodebuild -target 'UnitTest' -configuration Debug -sdk #{iphone_sdk}}
   print test_result
   if !test_result.include? 'BUILD SUCCEEDED'
     puts "unit tests failed"
     throw FailedTestsException.new
   end
  end
  
  desc "run a full clean and build then run"
  task :all => [ :clean, :test]
end