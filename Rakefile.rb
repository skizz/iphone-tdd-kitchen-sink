# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'rake'
require 'rake/clean'

CLOBBER.include 'tmp'

Dir["#{File.expand_path('..', __FILE__)}/rake/*.rake"].sort.each { |ext| load ext }

desc "default, alias for :test"
task :default => [:clean, :test]
