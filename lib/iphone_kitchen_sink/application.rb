# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module IphoneKitchenSink
  # Knows how to run the kitchen sink
  class Application
    def self.run(options)
      if options[:rake]
        ::IphoneKitchenSink::Rakefile.install
      end
      if options[:gtm]
        ::IphoneKitchenSink::GTM.install
      end
      if options[:frank]
        ::IphoneKitchenSink::Frank.install
      end
    end
  end
end
