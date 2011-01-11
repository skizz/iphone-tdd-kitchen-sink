# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require File.expand_path('../url_fetcher', __FILE__)

# Knows how to download and install Frank
class Frank
  def self.install
    checkout_dir = '/tmp/iphone-kitchen-sink/frank-clone'
    sh("git clone https://github.com/moredip/Frank.git #{checkout_dir}") unless File.exist?(checkout_dir)
    frank_dir = 'Vendor/Frank'
    mkdir_p frank_dir
    ['frank_static_resources.bundle', 'lib', 'src'].each do |f|
      cp_r "#{checkout_dir}/#{f}", frank_dir
    end
  end
end