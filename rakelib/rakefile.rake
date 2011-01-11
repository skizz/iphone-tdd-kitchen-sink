# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

namespace :install do

  desc "install rake"
  task :rake do
    require File.expand_path('../../lib/rakefile', __FILE__)
    Rakefile.install
  end

end
