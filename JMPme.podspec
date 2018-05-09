#
# Be sure to run `pod lib lint JMPme.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JMPme'
  s.version          = '0.1'
  s.summary          = '用于页面间路由跳转的库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  为了模块的解耦，使用路由的方式进行跳转。
                       DESC

  s.homepage         = 'https://git.tigerbrokers.net/ftiger_ios_group/Router'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JyHu' => 'auu.aug@gmail.com' }
  s.source           = { :git => 'https://git.tigerbrokers.net/ftiger_ios_group/Router.git', :tag => '0.1' }

  s.ios.deployment_target = '8.0'
  s.source_files = 'JMPme/**/*.{h,m}'
  
end
