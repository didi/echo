#
# Be sure to run `pod lib lint EchoSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EchoSDK'
  s.version          = '0.0.1'
  s.summary          = 'Echo调试工具SDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        Echo调试工具SDK.
                       DESC

  s.homepage         = 'https://github.com/didichuxing/echo'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chenaibin' => 'cocoa_chen@126.com' }
  s.source           = { :git => 'https://github.com/didichuxing/echo.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.13'

  # s.source_files = 'Sources/**/*'
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
  end

  # 插件层
  s.subspec 'Plugins' do |plugins|
    plugins.subspec 'Basic' do |ss|
      ss.source_files = 'Sources/Plugins/Basic/**/*'
    end
    plugins.subspec 'GeneralLog' do |ss|
      ss.source_files = 'Sources/Plugins/GeneralLog/**/*'
      ss.dependency "fishhook"
    end
    plugins.subspec 'MemoryLeak' do |ss|
      ss.source_files = 'Sources/Plugins/MemoryLeak/**/*'
      ss.dependency "MLeaksFinder"
      ss.dependency "RSSwizzle"
    end
    plugins.subspec 'MockGPS' do |ss|
      ss.source_files = 'Sources/Plugins/MockGPS/**/*'
      ss.dependency "JZLocationConverter"
    end
    plugins.subspec 'Network' do |ss|
      ss.source_files = 'Sources/Plugins/Network/**/*'
    end
    plugins.subspec 'Notification' do |ss|
      ss.source_files = 'Sources/Plugins/Notification/**/*'
    end
    plugins.subspec 'NSLog' do |ss|
      ss.source_files = 'Sources/Plugins/NSLog/**/*'
    end
    plugins.subspec 'UI' do |ss|
      ss.source_files = 'Sources/Plugins/UI/**/*'
    end
    plugins.subspec 'ViewBorder' do |ss|
      ss.source_files = 'Sources/Plugins/ViewBorder/**/*'
    end
    plugins.subspec 'Watchdog' do |ss|
      ss.source_files = 'Sources/Plugins/Watchdog/**/*'
      ss.dependency "BSBacktraceLogger"
    end
    plugins.subspec 'Crash' do |ss|
      ss.source_files = 'Sources/Plugins/Crash/**/*'
    end
    plugins.subspec 'NSUserDefaults' do |ss|
      ss.source_files = 'Sources/Plugins/NSUserDefaults/**/*'
    end

    plugins.dependency 'EchoSDK/Core'
    plugins.dependency 'EchoSDK/ClientSDK'
  end


end
