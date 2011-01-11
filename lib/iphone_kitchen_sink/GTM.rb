# Copyright (c) 2011 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'erb'

module IphoneKitchenSink
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

    def self.install(project_dir = '.')
      self.new.install(project_dir)
    end

    # Installs GTM from the +svn_base_url+
    def install(project_dir=".")
      project_dir = File.expand_path(project_dir)
      gtm_dir = "#{project_dir}/Vendor/Test/GTM"
      FILES.each do |file|
        file_path = "#{gtm_dir}/#{file}"
        url = "#{@svn_base_url}/#{file}"
        @fetcher.fetch(url, file_path)
      end

      add_hello_world_test(project_dir)

      images_dir = File.expand_path('../../../help/images/', __FILE__)
      File.open('/tmp/gtm-installed.html', 'w') do |f| 
        f.puts ERB.new(File.read(File.expand_path('../../../help/GTM.erb.html', __FILE__))).result(binding)
        `open #{f.path}` unless $0 =~ /rake|rcov|_test/

      end
    end

    private

    def add_hello_world_test(project_dir)
      test_dir = File.join(project_dir, 'Tests/Unit')
      mkdir_p test_dir
      cp File.expand_path('../../../templates/TestHelper.h', __FILE__), test_dir
      cp File.expand_path('../../../templates/HelloWorldTest.m', __FILE__), test_dir
    end
  
  end
end