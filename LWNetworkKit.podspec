
Pod::Spec.new do |s|
  s.name          = 'LWNetworkKit'
  s.version       = '1.0.0'  # ← 首发版本，和 Git tag 必须一致
  s.summary       = 'Lightweight network layer built on Alamofire.'
  s.description   = <<-DESC
A clean, composable networking kit with request building, interceptors, monitors, retry, coalescing, ETag, pinning, background transfer, SSE, and offline queue.
  DESC

  s.homepage      = 'https://github.com/linlishu8/LWNetworkKit'
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.authors       = { 'linlishu8' => 'lnilishu8@163.com' }

  # 你的仓库地址 + 版本 tag
  s.source        = { :git => 'https://github.com/linlishu8/LWNetworkKit.git', :tag => s.version.to_s }

  # 平台 & Swift 版本
  s.ios.deployment_target = '13.0'
  s.swift_versions = ['5.8', '5.9', '5.10']

  # 源码路径
  s.source_files  = 'Sources/LWNetworkKit/**/*.swift'

  # 示例等不进发布包的目录无需写；如有资源可用 s.resource_bundles
  # s.resource_bundles = { 'LWNetworkKitResources' => ['Sources/Resources/**/*'] }

  # 依赖
  s.dependency 'Alamofire', '~> 5.9'

  s.requires_arc = true
end
