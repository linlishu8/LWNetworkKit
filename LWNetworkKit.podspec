
Pod::Spec.new do |s|
  s.name             = 'LWNetworkKit'
  s.version          = '0.2.0'
  s.summary          = 'Networking with middleware, retry, coalescing, ETag, pinning, BG transfer, SSE, offline queue.'
  s.description      = 'iOS 14+, Alamofire-based pragmatic networking toolkit. CocoaPods example mirrors PRO12 demo features.'
  s.homepage         = 'https://example.invalid/lwnetworkkit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LW' => 'dev@example.com' }
  s.ios.deployment_target = '14.0'
  s.swift_versions   = ['5.7', '5.8', '5.9']
  s.source           = { :git => 'https://example.invalid/lwnetworkkit.git', :tag => s.version.to_s }
  s.source_files     = 'Sources/LWNetworkKit/**/*.{swift}'
  s.frameworks       = 'Security', 'Network'
  s.dependency       'Alamofire', '~> 5.8'
end
