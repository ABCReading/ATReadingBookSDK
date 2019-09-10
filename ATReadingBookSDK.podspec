#
# Be sure to run `pod lib lint ATReadingBookSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ATReadingBookSDK'
  s.version          = '2.1.5'
  s.summary          = 'ATReadingBookSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ATReadingBookSDK Copyright (c) 2018 ABC Reading. All rights reserved.
                       DESC

  s.homepage         = 'https://github.com/ABCReading/ATReadingBookSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Spaino' => 'captain_spaino@163.com' }
  s.source           = { :git => 'https://github.com/ABCReading/ATReadingBookSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

    #支持最小系统版本
    s.platform     = :ios, '8.0'

    #需要包含的源文件
    s.source_files = 'ATReadingBookSDK/Classes/*.framework/Headers/*.{h}'

    #你的SDK路径
    s.vendored_frameworks = 'ATReadingBookSDK/Classes/*.framework'

    #SDK头文件路径
    s.public_header_files = 'ATReadingBookSDK/Classes/*.framework/Headers/*.h'


   s.resource_bundles = {
     'ATReadingBookSDK' => ['ATReadingBookSDK/Assets/*.bundle']
   }
   
   valid_archs = ['arm64',
                 'x86_64',
                 'armv7',
                 'armv7s']
   s.xcconfig            = {
       'VALID_ARCHS'          =>  valid_archs.join(' '),
   }

  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'SSZipArchive', '~> 2.1.1'
   s.dependency 'JSONModel', '~> 1.7.0'
   s.dependency 'lottie-ios', '~> 2.5.0'
   s.dependency 'SDWebImage', '~> 4.0'
   s.dependency 'YYText', '~> 1.0.7'
   s.dependency 'Objective-LevelDB', '~> 2.1.5'
   s.dependency 'Qiniu', '~> 7.2.2'

end
