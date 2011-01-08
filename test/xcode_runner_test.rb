require 'test_helper'

class XUnitTestCollectorTest < Test::Unit::TestCase

def test_should_send_output_to_build_directory
  output_dir = File.join(File.dirname(__FILE__), '..', 'tmp')
  FileUtils.rm_rf(output_dir)
  FileUtils.mkdir(output_dir)
  
  cmd = 'ruby ' + File.join(File.dirname(__FILE__), 'simulate_xcode_build.rb')
    
  XCode.run :command => cmd, :target => 'target', :output_dir => output_dir
    
  assert File.exists?(File.join(output_dir, 'test_reports', 'target', 'TEST-SyncStatusTest.xml'))
end

def assert_matches(command, regex)
  assert command =~ regex, "Command [#{command}] does not match regex #{regex} "
end

def test_should_run_xcodebuild_with_target
  assert_matches XCode.new(:target => "My_Target").command, /-target 'My_Target'/
end

def test_should_run_xcodebuild_with_supplied_sdk
  assert_matches XCode.new(:sdk => "Some_SDK").command, /-sdk 'Some_SDK'/
end

def test_should_run_xcodebuild_with_supplied_configuration
  assert_matches XCode.new(:configuration => "Release").command, /-configuration 'Release'/
end

def test_should_return_output
  output_dir = File.join(File.dirname(__FILE__), '..', 'tmp')
  FileUtils.rm_rf(output_dir)
  FileUtils.mkdir(output_dir)

  cmd = "ruby -e \"puts 'Hello World!'\"" 
    
  output = XCode.run :command => cmd, :target => 'target', :output_dir => output_dir
    
  assert_equal "Hello World!\n", output 
end

end
