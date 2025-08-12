# Uncomment the next line to define a global platform for your project
platform :ios, '17.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

target 'BassUp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BassUp
  pod 'Alamofire', '~> 5.8'
  pod 'SwiftyJSON', '~> 5.0'
  pod 'SDWebImage', '~> 5.18'
  pod 'SnapKit', '~> 5.6'
  pod 'RxSwift', '~> 6.6'
  pod 'RxCocoa', '~> 6.6'
  pod 'Kingfisher', '~> 7.10'
  pod 'Lottie', '~> 4.3'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'RealmSwift', '~> 10.42'
  pod 'IQKeyboardManagerSwift', '~> 6.5'
  pod 'NVActivityIndicatorView', '~> 5.1'
  pod 'Toast-Swift', '~> 5.0'
  pod 'Permission/Notifications'
  pod 'Permission/Camera'
  pod 'Permission/PhotoLibrary'
  pod 'Permission/Microphone'
  pod 'Permission/LocationWhenInUse'

  target 'BassUpTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick', '~> 7.0'
    pod 'Nimble', '~> 13.0'
    pod 'Mockingbird', '~> 0.20'
  end

  target 'BassUpUITests' do
    # Pods for testing
    pod 'Quick', '~> 7.0'
    pod 'Nimble', '~> 13.0'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
      
      # Enable arm64 for iOS Simulator
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = ''
      
      # Enable bitcode
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      
      # Swift version
      config.build_settings['SWIFT_VERSION'] = '5.9'
      
      # Enable modular headers
      config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
    end
  end
end
