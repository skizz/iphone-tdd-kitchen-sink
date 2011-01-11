# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module IphoneKitchenSink
  # Knows how to run the kitchen sink
  class Application
    def self.run(options)
      puts options.inspect
    end
  end
end