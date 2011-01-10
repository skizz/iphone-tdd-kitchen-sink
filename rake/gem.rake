# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'rubygems'
require 'rake/gempackagetask'

namespace :release do
  desc 'Update the changelog'
  task :changelog do
    File.open(File.join(File.dirname(__FILE__), '..', 'CHANGELOG'), 'w+') do |changelog|
      require 'time'
      `git log -z --abbrev-commit`.split("\0").each do |commit|
        next if commit =~ /^Merge: \d*/
        ref, author, time, _, title, _, message = commit.split("\n", 7)
        ref    = ref[/commit ([0-9a-f]+)/, 1]
        author = author[/Author: (.*)/, 1].strip
        time   = Time.parse(time[/Date: (.*)/, 1]).utc
        title.strip!

        changelog.puts "[#{ref} | #{time}] #{author}"
        changelog.puts '', "  * #{title}"
        changelog.puts '', message.rstrip if message
        changelog.puts
      end
    end
  end
  
  desc 'Create the iphone-tdd-kitchen-sink gem'
  task :gem => :changelog do
    Rake::Task['release:copyright'].invoke
    files = ['README.textile', 'MIT-LICENSE.txt']

    spec = Gem::Specification.new do |s|
      s.name = "iphone-tdd-kitchen-sink"
      s.version           = "0.1.0"
      s.author            = "ThoughtWorks, Inc."
      s.email             = "ketan@thoughtworks.com"
      s.homepage          = "http://github.com/ketan/iphone-tdd-kitchen-sink"
      s.platform          = Gem::Platform::RUBY
      s.summary           = "The The iPhone TDD Kitchen Sink is a set of ruby scripts to quickly be able to setup a testing environment for iPhone applications."
      s.description       = "The The iPhone TDD Kitchen Sink is a set of ruby scripts to quickly be able to setup a testing environment for iPhone applications."
      s.files             = Dir["{lib,test,rake,help}/*"] + ["#{s.name}.gemspec", "README.textile", 'MIT-LICENSE.txt', "CHANGELOG"]
      s.has_rdoc          = false
      s.extra_rdoc_files  = ["README.textile", "MIT-LICENSE.txt"]
    end
    
    File.open("#{spec.name}.gemspec", "w") { |f| f << spec.to_ruby }
    
    sh "gem build #{spec.name}.gemspec"
    
    # move it into a proper directory
    rm_rf "./pkg", :verbose => false
    mkdir "./pkg", :verbose => false
    mv "#{spec.name}-#{spec.version}.gem", "./pkg", :verbose => false
    rm 'CHANGELOG'
    rm "#{spec.name}.gemspec"
  end
  
  desc 'Push the gem out to gemcutter'
  task :push => [:test, :gem] do
    
    puts <<-INSTRUCTIONS
    
      ==============================================================
      Instructions before you push out:
      * Make sure everything is good
      * Bump the version number in the `gem.rake' file
      * Check in
      * Run this task again to:
        * verify everything is good
        * generate a new gem with the new version number
      * Create a tag in git:
        $ git tag -a -m 'Tag for version X.Y.Z' 'vX.Y.Z'
        $ gem push pkg/iphone-tdd-kitchen-sink-X.Y.Z.gem
      ==============================================================
    INSTRUCTIONS
    # sh("gem push pkg/*.gem") do |res, ok|
    #   raise 'Could not push gem' if !ok
    # end
  end

end
