# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'Volume' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Volume
  pod 'Apollo'
  pod 'AppDevAnalytics', :git => 'https://github.com/cuappdev/analytics-ios.git', :commit => '5d459c0475'
  pod 'AppDevAnnouncements', :git => 'https://github.com/cuappdev/appdev-announcements.git'
  pod 'Firebase/Messaging'
  pod 'lottie-ios'
  pod 'SDWebImageSwiftUI'
  pod 'SDWebImageSVGCoder'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end