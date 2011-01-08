
require 'FileUtils'

#
# Understands lines that are interesting and should be output to the console
#
class ConsoleFilter
  
  def initialize(out)
    @out = out
    @in_test = false
  end
  
  def line(text)
    if text =~ /Test Suite '.*' started at .*/
      @in_test = true
    end
    
    @out << text if text =~ /===.*===/ || text =~ /^Test Suite/ || text =~ /^Test Case/ 
    
    if text =~ /Executed .* tests, with .* failures \(.* unexpected\) in .*/
      @out << text
      @out << ""
    end

  end
  
end

#
# Understands how to produce xunit xml output from an xcode log file
#  
class XUnitTestCollector
  
  attr_reader :tests
  
  def initialize(output_dir)
    @output_dir = output_dir
    @current_tests = []
    @current_output = []
  end
  
  def line(text)
    if text =~ /Test Suite \'(.*)\' started at (.*)/
      @current_suite = $1
      @timestamp = $2
      @current_output = []
    elsif text =~ /Executed (\d+) tests, with (\d+) failures \((\d+) unexpected\) in (.*) \(.*\) seconds/      
      @tests = { :suite => @current_suite, 
        :tests => @current_tests, 
        :suite_duration => $4, 
        :timestamp=>@timestamp, 
        :total_tests => $1,
        :errors => $3,
        :failures => $2 }
      write_xml @tests
      @current_tests = []
    elsif text =~ /Test Case \'(.*)\' (\w+) \((.*) seconds\)\./
      result = $2
      @current_tests << { :test_name => $1, :result => result, :duration => $3, :output => @current_output }
      @current_output = []
    else 
      @current_output << text
    end
  end
  
  def write_xml(tests)
    File.open(@output_dir + "/TEST-#{tests[:suite]}.xml", "w") do |f|
      f.puts %{<testsuite errors="#{tests[:errors]}" failures="#{tests[:failures]}" hostname="UNKNOWN" name="#{tests[:suite]}" tests="#{tests[:total_tests]}" time="#{tests[:suite_duration]}" timestamp="#{tests[:timestamp]}">}
      tests[:tests].each do |test|
        f.puts %{  <testcase classname="#{tests[:suite]}" name="#{test[:test_name]}" time="#{test[:duration]}" >}
        if test[:result] != 'passed'
          f.puts %{    <failure message="Test failed" type="failure" >}
          test[:output].each do |line|
            f.puts line
          end
          f.puts %{   </failure>}
        end
        f.puts %{  </testcase>}
      end
      f.puts %{</testsuite>}
    end
  end
  
end

class XCode

  class << self
    
    def run(params)
      xcode = XCode.new(params) 
      xcode.run_command
    end
    
  end
  
  def initialize(params)
    @params = params
  end
  
  def output_dir
    @params[:output_dir] || 'build'
  end
  
  def run_command
    test_output_dir = File.join(output_dir, 'test_reports', @params[:target])

    FileUtils.rm_rf(test_output_dir) if File.exists?(test_output_dir)
    FileUtils.mkdir_p(test_output_dir)

    collector = XUnitTestCollector.new(test_output_dir)

    log = ""

    output = IO.popen(command)
    while (!output.eof?)
      line = output.readline
      collector.line(line)
      log << line
    end

    log
  end
  
  def command
    @params[:command] || "xcodebuild -target '#{@params[:target]}' -configuration '#{@params[:configuration]}' -sdk '#{@params[:sdk]}'"
  end
end

