import SwiftUI
import LWNetworkKit
struct LimiterBreakerDemo: View {
  @State private var out = "Tap to burst"; var client: LWAlamofireClient { var cfg = LWNetworkConfig(); cfg.middlewares = [ LWTokenBucketLimiter(rate: 2, burst: 3), LWCircuitBreaker(name:"demo", failureThreshold:3, rollingSeconds:5, halfOpenAfter:3) ]; return LWAlamofireClient(config: cfg, interceptor: LWAuthInterceptor(), monitors: []) }
  var body: some View { VStack(spacing:12){ Text(out).frame(maxWidth:.infinity, alignment:.leading).padding().background(Color(.secondarySystemBackground)).cornerRadius(8); Button("Burst 6 req") { Task { await run() } }.buttonStyle(LWProminentButtonStyle()) }.padding() }
  func run() async { do { async let a = hit(); async let b = hit(); async let c = hit(); async let d = hit(); async let e = hit(); async let f = hit(); let results = try await [a,b,c,d,e,f]; out = results.joined(separator:"\n") } catch { out = "Error: \(error)" } }
  func hit() async throws -> String { struct R:Decodable{ let status:String }; let ep = LWAPI(env:.prod, path:"/v1/limiter", method:.get, requiresAuth: false); let r:R = try await client.request(ep, as: R.self); return r.status }
}
