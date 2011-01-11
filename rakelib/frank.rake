# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

namespace :install do
  
  desc "install frank"
  task :frank do
    require File.expand_path('../../lib/frank', __FILE__)
    Frank.install
  end
  
end