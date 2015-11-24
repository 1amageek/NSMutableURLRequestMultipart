Pod::Spec.new do |s|

  s.name         = "NSMutableURLRequestMultipart"
  s.version      = "0.1.3"
  s.summary      = "NSMutableURLRequestMultipart is a category of NSMutableURLRequest for sending a simple POST request."
  s.homepage     = "https://github.com/1amageek/NSMutableURLRequestMultipart"
  #s.screenshots	 = ""
  s.license      = { :type => "MIT" }
  s.author       = { "1_am_a_geek" => "tmy0x3@icloud.com" }
  s.social_media_url   = "http://twitter.com/1_am_a_geek"
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"

  s.source       = { :git => "https://github.com/1amageek/NSMutableURLRequestMultipart.git", :tag => "0.1.3" }
  s.source_files  = ["NSMutableURLRequestMultipart/**/*.{h,m}"]
  s.exclude_files = ["NSMutableURLRequestMultipart/AppDelegate.*", "NSMutableURLRequestMultipart/ViewController.*","NSMutableURLRequestMultipart/main.m"]
  s.public_header_files = "NSMutableURLRequestMultipart/**/*.h"
  s.frameworks	= ["MobileCoreServices"]

end
