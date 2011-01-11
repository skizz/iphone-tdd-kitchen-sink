# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'test_helper'

require 'rakefile'
class RakefileTest < Test::Unit::TestCase
  include FileUtils
  TMP_DIR = File.expand_path('../../tmp', __FILE__)
  
  def setup
    rm_rf TMP_DIR, :verbose => false
    mkdir_p TMP_DIR, :verbose => false
  end
  
  def test_should_create_rakefile_if_one_does_not_exist
    Rakefile.install(TMP_DIR)
    assert File.exists?("#{TMP_DIR}/Rakefile.rb")
    assert_equal File.read(File.expand_path('../../templates/Rakefile.rb', __FILE__)), File.read("#{TMP_DIR}/Rakefile.rb")
  end
  
  def test_should_create_a_different_rakefile_if_one_already_exists
    rakefile_contents = '# some rakefile, does not matter what it contains'
    File.open("#{TMP_DIR}/Rakefile.rb", 'w') {|f| f.puts rakefile_contents}
    Rakefile.install(TMP_DIR)
    assert File.exists?("#{TMP_DIR}/Rakefile.rb")
    assert_equal File.read(File.expand_path('../../templates/Rakefile.rb', __FILE__)), File.read("#{TMP_DIR}/rakelib/iphone-kitchen-sink.rake")
  end
end
