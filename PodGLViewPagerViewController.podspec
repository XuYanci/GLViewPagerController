#
# Be sure to run `pod lib lint podTestLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'GLViewPagerViewController' 
  s.version          = '1.0.0'
  s.summary          = 'ViewPager'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
GLViewPagerViewController is an common public control, it is usally used in news, here use UIPageViewController and UIScrollView as tab container to build it.
                       DESC
  s.homepage         = 'https://github.com/XuYanci/GLViewPagerController.git' ()
   s.screenshots     = 'https://github.com/XuYanci/GLViewPagerController/blob/master/readme%7Eresource/present_viewpager.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'XuYanci' => 'grandy.wind@gmail.com' }
  # @note 第一步生成gitrepo地址
  s.source           = { :git => 'https://github.com/XuYanci/GLViewPagerController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '8.0'
  # @note 第一步生成的目录,用于存放Lib源文件 (.h,.m)
  s.source_files = 'PodGLViewPagerViewController/Classes/**/*'
  # @note 第一步生成的目录,用于存放Lib资源文件 (.png)
  s.resource_bundles = {
     'PodGLViewPagerViewController' => ['PodGLViewPagerViewController/Assets/*.png']
   }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
