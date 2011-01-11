# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'net/http'

class URLFetcher
  include FileUtils
  def self.fetch(url, out_file)
    mkdir_p(File.dirname(out_file)) unless File.exist?(File.dirname(out_file))

    File.open(out_file, 'w') do |f|
      puts "Fetching #{url} into #{out_file}"
      contents = Net::HTTP.get_response(URI.parse(url)).body
      f.puts(contents)
    end
  end
end
