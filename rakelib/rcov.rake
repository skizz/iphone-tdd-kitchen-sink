# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

begin
  require 'rcov/rcovtask'
rescue LoadError
  raise 'Could not find the rcov gem, please run `gem install rcov` to get some metrics'
end

CLOBBER.include 'reports/coverage'

namespace :test do
  namespace :coverage do
    desc "Open code coverage reports in a browser."
    task :show => 'test:coverage' do
      system("open reports/coverage/index.html")
    end
  end
  
  
  task :init do
    mkdir_p 'reports/coverage'
  end
  
  desc 'Aggregate code coverage for unit tests'
  Rcov::RcovTask.new(:coverage => :init) do |t|
    t.libs << "test"
    t.test_files = FileList["test/**/*_test.rb"]
    t.output_dir = "reports/coverage"
    t.verbose = true
    t.rcov_opts << '--exclude gems'
    t.rcov_opts << '--exclude "yaml,parser.y,racc,(erb),(eval),(recognize_optimized),erb"' if RUBY_PLATFORM =~ /java/
    t.rcov_opts << '--include-file "\./lib/.*\.rb" --html'
  end
end
