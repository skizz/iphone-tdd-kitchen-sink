# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'test_helper'

module IphoneKitchenSink
  class GTMTest < Test::Unit::TestCase
    include FileUtils
    TMP_DIR = File.expand_path('../../tmp', __FILE__)
  
    def setup
      rm_rf TMP_DIR, :verbose => false
      mkdir_p TMP_DIR, :verbose => false
    end
    
    def test_should_install_frank
      GTM.install("#{TMP_DIR}/gtm_dir")
      GTM::FILES.each do |f|
        assert File.exists?("#{TMP_DIR}/gtm_dir/#{f}"), "Could not find file/folder #{f} inside the install location."
      end      
    end
  end
end