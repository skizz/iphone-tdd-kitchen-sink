# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'test_helper'

module IphoneKitchenSink
  class CLIParserTest < Test::Unit::TestCase
    def test_should_parse_rake_options
      assert CLIParser.parse(['-r'])[:rake]
      assert !CLIParser.parse(['--no-rake'])[:rake]
    end
    
    def test_should_parse_gtm_options
      assert CLIParser.parse(['-g'])[:gtm]
      assert !CLIParser.parse(['--no-gtm'])[:gtm]
    end
    
    def test_should_parse_frank_options
      assert CLIParser.parse(['-f'])[:frank]
      assert !CLIParser.parse(['--no-frank'])[:frank]
    end
  end
end