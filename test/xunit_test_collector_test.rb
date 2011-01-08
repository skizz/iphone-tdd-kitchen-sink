require 'test_helper'

require 'fileutils'
require 'rexml/document'

class XUnitTestCollectorTest < Test::Unit::TestCase

PASSING_SUITE = <<END
Test Suite 'HotSessionsTest' started at 2010-05-20 18:36:53 -0700
Test Case '-[HotSessionsTest testGetHotSessionsFromService]' passed (0.003 seconds).
Test Suite 'HotSessionsTest' finished at 2010-05-20 18:36:53 -0700.
Executed 1 tests, with 0 failures (0 unexpected) in 0.003 (0.003) seconds
END

FAILING_TEST = <<-FAILING
Test Suite 'ScheduleImporterTest' started at 2010-05-20 18:36:53 -0700

LOTS OF TEXT IN HERE

LOTS OF TEXT IN HERE

LOTS OF TEXT IN HERE

LOTS OF TEXT IN HERE

/Users/skizz/Development/go-iphone/conf_conxn/iPhone/UnitTests/ScheduleImporterTest.m:32: error: -[ScheduleImporterTest testShouldSaveARowOfSession] : 'XXXThis is here to force it to fail.
' should be equal to '- Michael Darviche, Acxiom
- Prasanna Dhore, Hewlett-Packard
'.
Test Case '-[ScheduleImporterTest testShouldSaveARowOfSession]' failed (0.636 seconds).
Test Case '-[ScheduleImporterTest testShouldSaveARowOfSession2]' failed (0.017 seconds).
Test Case '-[ScheduleImporterTest anotherTest]' passed (0.003 seconds).
Test Suite 'ScheduleImporterTest' finished at 2010-05-20 18:36:53 -0700.
Executed 99 tests, with 5 failures (3 unexpected) in 0.018 (0.018) seconds
FAILING

  def setup
    FileUtils.rm_rf("../tmp")
    FileUtils.mkdir("../tmp")
    @collector = XUnitTestCollector.new("../tmp")
  end

  def test_should_collect_a_test_suite_name
    FAILING_TEST.each_line { |line| @collector.line(line) }

    assert_equal "ScheduleImporterTest", @collector.tests[:suite]
    assert_equal "0.018", @collector.tests[:suite_duration]
    assert_equal "2010-05-20 18:36:53 -0700", @collector.tests[:timestamp]
  end

  def test_should_include_failed_tests
    error_details = <<-ERROR

LOTS OF TEXT IN HERE

LOTS OF TEXT IN HERE

LOTS OF TEXT IN HERE

LOTS OF TEXT IN HERE

/Users/skizz/Development/go-iphone/conf_conxn/iPhone/UnitTests/ScheduleImporterTest.m:32: error: -[ScheduleImporterTest testShouldSaveARowOfSession] : 'XXXThis is here to force it to fail.
' should be equal to '- Michael Darviche, Acxiom
- Prasanna Dhore, Hewlett-Packard
'.
ERROR

    FAILING_TEST.each_line { |line| @collector.line(line) }

    assert_equal 3, @collector.tests[:tests].size, @collector.tests.inspect
    assert_equal "-[ScheduleImporterTest testShouldSaveARowOfSession]", @collector.tests[:tests][0][:test_name], @collector.tests.inspect
    assert_equal "failed", @collector.tests[:tests][0][:result], @collector.tests.inspect
    assert_equal "0.636", @collector.tests[:tests][0][:duration], @collector.tests.inspect
    assert_equal error_details.lines.collect, @collector.tests[:tests][0][:output], @collector.tests.inspect
  end

  def test_should_include_passing_tests
    collector = XUnitTestCollector.new("tmp")
    PASSING_SUITE.each_line { |line| @collector.line(line) }

    assert_equal 1, @collector.tests[:tests].size, @collector.tests.inspect
    assert_equal "-[HotSessionsTest testGetHotSessionsFromService]", @collector.tests[:tests][0][:test_name], @collector.tests.inspect
    assert_equal "passed", @collector.tests[:tests][0][:result], @collector.tests.inspect
    assert_equal "0.003", @collector.tests[:tests][0][:duration], @collector.tests.inspect
  end

  def test_should_write_test_xml
        error_details = <<-ERROR

    LOTS OF TEXT IN HERE

    LOTS OF TEXT IN HERE

    LOTS OF TEXT IN HERE

    LOTS OF TEXT IN HERE

    /Users/skizz/Development/go-iphone/conf_conxn/iPhone/UnitTests/ScheduleImporterTest.m:32: error: -[ScheduleImporterTest testShouldSaveARowOfSession] : 'XXXThis is here to force it to fail.
    ' should be equal to '- Michael Darviche, Acxiom
    - Prasanna Dhore, Hewlett-Packard
    '.
    ERROR

    FAILING_TEST.each_line { |line| @collector.line(line) }
    result = REXML::Document.new(IO.read("../tmp/TEST-ScheduleImporterTest.xml"))
    assert_equal "3", REXML::XPath.first( result, "//testsuite/@errors" ).value
    assert_equal "5", REXML::XPath.first( result, "//testsuite/@failures" ).value
    assert_equal "ScheduleImporterTest", REXML::XPath.first( result, "//testsuite/@name" ).value
    assert_equal "0.018", REXML::XPath.first( result, "//testsuite/@time" ).value
    assert_equal "2010-05-20 18:36:53 -0700", REXML::XPath.first( result, "//testsuite/@timestamp" ).value

    assert_equal "ScheduleImporterTest", REXML::XPath.first( result, "//testsuite/testcase/@classname" ).value
    assert_equal "-[ScheduleImporterTest testShouldSaveARowOfSession]", REXML::XPath.first( result, "//testsuite/testcase/@name" ).value
    assert_equal "0.636", REXML::XPath.first( result, "//testsuite/testcase/@time" ).value

    assert_equal "Test failed", REXML::XPath.first( result, "//testsuite/testcase/failure/@message" ).value
    assert_equal "failure", REXML::XPath.first( result, "//testsuite/testcase/failure/@type" ).value
    assert REXML::XPath.first( result, "//testsuite/testcase/failure" ).text =~ /XXXThis is here to force it to fail/
  end


end
