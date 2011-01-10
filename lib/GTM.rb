# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'rubygems'
require 'rake'
require 'net/http'
require 'erb'

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

# Knows how to download and install GTM
class GTM
  FILES = %w[UnitTesting/GTMIPhoneUnitTestMain.m
    UnitTesting/GTMIPhoneUnitTestDelegate.m
    UnitTesting/GTMIPhoneUnitTestDelegate.h
    UnitTesting/GTMSenTestCase.m
    UnitTesting/GTMSenTestCase.h
    UnitTesting/GTMUnitTestDevLog.m
    UnitTesting/GTMUnitTestDevLog.h
    UnitTesting/RunIPhoneUnitTest.sh
    Foundation/GTMObjC2Runtime.m
    Foundation/GTMObjC2Runtime.h
    Foundation/GTMRegex.m
    Foundation/GTMRegex.h
    GTMDefines.h]
  
  def initialize(svn_base_url = 'http://google-toolbox-for-mac.googlecode.com/svn/tags/google-toolbox-for-mac-1.6.0', fetcher = URLFetcher)
    @svn_base_url = svn_base_url
    @fetcher = fetcher
  end
  
  # Installs GTM from the +svn_base_url+
  def install
    gtm_dir = File.expand_path("./Vendor/Test/GTM")
    FILES.each do |file|
      file_path = "#{gtm_dir}/#{file}"
      url = "#{@svn_base_url}/#{file}"
      @fetcher.fetch(url, file_path)
    end
    
    add_hello_world_test
    
    File.open('/tmp/gtm-installed.html', 'w') do |f| 
      f.puts ERB.new(File.read(File.expand_path('../../help/GTM.erb.html', __FILE__))).result(binding)
      `open #{f.path}`
    end
  end

  private
  
  def add_hello_world_test
    mkdir_p 'Tests/Unit'
    cp File.expand_path('../../help/TestHelper.h', __FILE__), 'Tests/Unit'
    cp File.expand_path('../../help/HelloWorldTest.m', __FILE__), 'Tests/Unit'
  end
  
end