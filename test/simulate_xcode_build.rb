LOG_FILE = File.join(File.dirname(__FILE__), 'data', 'build.log')
File.open(LOG_FILE).each_line do |line|
  puts line
end

