#
# Be sure to run `pod lib lint EchoSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EchoSDK'
  s.version          = '0.0.3'
  s.summary          = 'Echo调试工具SDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        Echo调试工具SDK.
                       DESC

  s.homepage         = 'https://github.com/didi/echo'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chenaibin' => 'cocoa_chen@126.com' }
  s.source           = { :git => 'https://github.com/didi/echo.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.13'

  s.default_subspecs = 'Plugins'

  s.resource_bundles = {
    'EchoSDKResource' => ['Sources/Resources/**/*']
  }

  s.dependency "CocoaAsyncSocket"

  # 核心层
  s.subspec 'Core' do |core|
  	core.source_files = 'Sources/Core/**/*'
  end

  # SDK层
  s.subspec 'ClientSDK' do |client_sdk|
    client_sdk.source_files = 'Sources/Client/**/*'
    client_sdk.dependency 'EchoSDK/Core'
  end

  # 插件层
  s.subspec 'Plugins' do |plugins|
    plugins.subspec 'Basic' do |ss|
      ss.ios.source_files = 'Sources/Plugins/Basic/**/*'
    end
    plugins.subspec 'GeneralLog' do |ss|
      ss.ios.source_files = 'Sources/Plugins/GeneralLog/**/*'
      ss.ios.dependency "fishhook"
    end
    plugins.subspec 'MemoryLeak' do |ss|
      ss.ios.source_files = 'Sources/Plugins/MemoryLeak/**/*'
      ss.ios.dependency "MLeaksFinder"
      ss.ios.dependency "RSSwizzle"
    end
    plugins.subspec 'MockGPS' do |ss|
      ss.ios.source_files = 'Sources/Plugins/MockGPS/**/*'
      ss.ios.dependency "JZLocationConverter"
      ss.ios.dependency 'EchoSDK/Plugins/Basic'
    end
    plugins.subspec 'Network' do |ss|
      ss.ios.source_files = 'Sources/Plugins/Network/**/*'
      ss.ios.dependency 'EchoSDK/Plugins/Basic'
    end
    plugins.subspec 'Notification' do |ss|
      ss.ios.source_files = 'Sources/Plugins/Notification/**/*'
      ss.ios.dependency 'EchoSDK/Plugins/Basic'
    end
    plugins.subspec 'NSLog' do |ss|
      ss.ios.source_files = 'Sources/Plugins/NSLog/**/*'
      ss.ios.dependency 'EchoSDK/Plugins/Basic'
      ss.ios.dependency "fishhook"
    end
    plugins.subspec 'UI' do |ss|
      ss.ios.source_files = 'Sources/Plugins/UI/**/*'
    end
    plugins.subspec 'ViewBorder' do |ss|
      ss.ios.source_files = 'Sources/Plugins/ViewBorder/**/*'
      ss.ios.dependency 'EchoSDK/Plugins/Basic'
    end
    plugins.subspec 'Watchdog' do |ss|
      ss.ios.source_files = 'Sources/Plugins/Watchdog/**/*'
      ss.ios.dependency "BSBacktraceLogger"
    end
    plugins.subspec 'Crash' do |ss|
      ss.ios.source_files = 'Sources/Plugins/Crash/**/*'
    end
    plugins.subspec 'NSUserDefaults' do |ss|
      ss.ios.source_files = 'Sources/Plugins/NSUserDefaults/**/*'
    end

    plugins.ios.dependency 'EchoSDK/Core'
    plugins.ios.dependency 'EchoSDK/ClientSDK'
  end

end