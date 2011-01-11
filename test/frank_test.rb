# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'test_helper'

module IphoneKitchenSink
  class FrankTest < Test::Unit::TestCase
    include FileUtils
    TMP_DIR = File.expand_path('../../tmp', __FILE__)
  
    def setup
      rm_rf TMP_DIR, :verbose => false
      mkdir_p TMP_DIR, :verbose => false
    end
    
    def test_should_install_frank
      Frank.install("#{TMP_DIR}/iphone-project", "#{TMP_DIR}/frank-clone")
      assert File.exists?("#{TMP_DIR}/frank-clone/.git")
      ['frank_static_resources.bundle', 'lib', 'src'].each do |f|
        assert File.exists?("#{TMP_DIR}/iphone-project/#{f}"), "Could not find file/folder #{f} inside the install location."
      end      
    end
  end
end