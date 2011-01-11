# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

namespace :install do
  
  desc "install GTM"
  task :gtm do
    require File.expand_path('../../lib/GTM', __FILE__)
    GTM.new.install
  end
  
end