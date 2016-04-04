Pod::Spec.new do |s|
  s.name         = "FirebaseUI"
  s.version      = "0.3.2"
  s.summary      = "UI binding libraries for Firebase."
  s.homepage     = "https://github.com/firebase/FirebaseUI-iOS"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Firebase" => "support@firebase.com" }
  s.social_media_url = "https://twitter.com/firebase"
  s.source       = { :git => "https://github.com/firebase/FirebaseUI-iOS.git", :tag => 'v0.3.2' }
  s.platform = :ios
  s.ios.deployment_target = "8.0"
  s.dependency "Firebase/Database"
  s.ios.framework = "UIKit"
  s.xcconfig     = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/Firebase"' }
  s.requires_arc = true
  s.default_subspecs = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = "FirebaseUI/{Core,Util}/**/*.{h,m}"
  end
end
