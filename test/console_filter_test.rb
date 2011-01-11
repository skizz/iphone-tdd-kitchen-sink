# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'test_helper'

module IphoneKitchenSink
  class ConsoleFilterTest < Test::Unit::TestCase
  
    def test_should_emit_build_target
      assert_emits_line "=== BUILD NATIVE TARGET UnitTest OF PROJECT ConferenceConnection WITH CONFIGURATION Debug ==="
    end
  
    def test_should_not_emit_other_lines
      assert_ignores_line "something else"
    end

    def test_should_emit_tests
      assert_emits_line "Test Suite '/Users/skizz/Development/go-iphone/conf_conxn/iPhone/build/Debug-iphonesimulator/UnitTest.app' started at 2010-05-20 18:36:53 -0700"
      assert_emits_line "Test Case '-[ScheduleImporterTest testShouldSaveARowOfSession]' failed (0.017 seconds)."
      assert_emits_line "Test Suite 'ScheduleImporterTest' finished at 2010-05-20 18:36:53 -0700."    
      assert_emits_line "Test Suite '/Users/skizz/Development/go-iphone/conf_conxn/iPhone/build/Debug-iphonesimulator/UnitTest.app' finished at   2010-05-20 18:36:54 -0700."
    end

    def test_should_emit_test_summaries
      result = process_line("Executed 2 tests, with 0 failures (0 unexpected) in 0.042 (0.042) seconds")
      assert_equal ["Executed 2 tests, with 0 failures (0 unexpected) in 0.042 (0.042) seconds", ""], result
    end
  
    def test_should_emit_compilation_failures
      fail "TODO"
    end
  
    def assert_emits_line(build_target_line)
      result = process_line(build_target_line)
      assert result.member?(build_target_line), "Got: #{result.inspect}"
    end

    def process_line(build_target_line)
      result = []
      f = ConsoleFilter.new(result)
      f.line build_target_line
      result
    end 
  
    def assert_ignores_line(build_target_line)
      result = process_line(build_target_line)
      assert_equal 0, result.size, "Result was #{result.inspect}"
    end
  
  end
end