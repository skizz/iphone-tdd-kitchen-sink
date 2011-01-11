# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'rubygems'
require 'rake'

class Rakefile
  
  include FileUtils
  
  DEFAULT_RAKEFILES = Rake::Application::DEFAULT_RAKEFILES
  
  def self.install(dir='.')
    dir = File.expand_path(dir)
    rakefile = 'Rakefile.rb'
    unless DEFAULT_RAKEFILES.select{|rf| File.exists?(File.join(dir, rf))}.empty?
      dir = "#{dir}/rakelib"
      rakefile = 'iphone-kitchen-sink.rake'
    end
    mkdir_p dir
    cp_r File.expand_path('../../templates/Rakefile.rb', __FILE__), File.join(dir, rakefile)
  end
end