# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

LOG_FILE = File.join(File.dirname(__FILE__), 'data', 'build.log')
File.open(LOG_FILE).each_line do |line|
  puts line
end

