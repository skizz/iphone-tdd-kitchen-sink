# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'rubygems'
require 'rake'

Dir[File.expand_path("../iphone_kitchen_sink/", __FILE__) +  "/*.rb"].each {|f| require f}
