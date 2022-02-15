Pod::Spec.new do |spec|
  spec.name         = "AnalyticsKit"
  spec.version      = "1.0.0"
  spec.summary      = "Broniboy AnalyticsKit"
  spec.description  = <<-DESC
  Broniboy AnalyticsKit
  DESC
  spec.homepage     = "https://broniboy.ru"
  spec.license      = "BSD"
  spec.author       = { 'Broniboy' => 'mail@broniboy.ru' }
  spec.platform     = :ios, "13.0"
  spec.swift_version = "5.3"
  spec.source       = { :git => "git@github.com:Broniboy-Dev/analytics-kit-ios.git" }
  
  spec.source_files = 'Sources/AnalyticsKit/**/*.{swift}'
  
  spec.ios.deployment_target = '13.0'
  
  spec.dependency 'Amplitude'
  spec.dependency 'Adjust'
  spec.dependency 'CleverTap-iOS-SDK'
  spec.dependency 'FirebaseAnalytics'
  spec.dependency 'FirebaseCrashlytics'
  spec.dependency 'FirebaseMessaging'
end
