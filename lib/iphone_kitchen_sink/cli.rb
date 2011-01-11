# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'optparse'

module IphoneKitchenSink
  
  # Knows how to parse command line arguments
  class CLIParser
    DEFAULT_OPTS = {
      :rake => true,
      :gtm => true,
      :frank => true,
      :verbose => true
    }
    
    def self.parse(args)
      options = DEFAULT_OPTS
      opts = OptionParser.new do |opts|
        opts.banner = "Usage $0 [options]"

        opts.separator ""
        opts.separator "Options:"
        
        opts.on("-q", "--quiet", "Run quietly(default is to run verbose)") do |verbose|
          options[:verbose] = !verbose
        end
        
        opts.on('-r', "--[no-]rake", "Install rake tasks(default is to install)") do |install|
          options[:rake] = install
        end
        
        opts.on('-g', "--[no-]gtm", "Install GTM for unit tests(default is to install)") do |install|
          options[:gtm] = install
        end
        
        opts.on('-f', "--[no-]frank", "Install Frank for UI Tests(default is to install)") do |install|
          options[:frank] = install
        end
        
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
        
        opts.on_tail('-V', "--version", "Show version") do
          require 'version'
          puts IphoneKitchenSink::VERSION
          exit
        end
      end
      opts.parse!(args)
      options
    end
  end
end
