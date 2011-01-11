# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'rake'
require 'rake/clean'

CLOBBER.include 'tmp'

desc "default, alias for :test"
task :default => [:clean, :test]
