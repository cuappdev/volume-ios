# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

# Ignore Warnings
inhibit_all_warnings!

target 'Volume' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Volume
  pod 'Alamofire'
  pod 'Apollo'
  pod 'AppDevAnalytics', :git => 'https://github.com/cuappdev/analytics-ios.git', :commit => '5d459c0475'
  pod 'AppDevAnnouncements', :git => 'https://github.com/cuappdev/appdev-announcements.git'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Messaging'
  pod 'lottie-ios'
  pod 'SDWebImageSwiftUI'
  pod 'SDWebImageSVGCoder'
  pod 'SwiftLint', :inhibit_warnings => false

end

# Supported range of deployment target versions: 11.0 - 16.1.99
post_install do |installer|
  installer.pods_project.targets.each do |target|
   target.build_configurations.each do |config|
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
   end
  end
end