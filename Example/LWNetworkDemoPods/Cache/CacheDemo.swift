import SwiftUI
import LWNetworkKit
import Alamofire

struct CacheDemo: View {
  @State private var out = "Tap GET twice within TTL"
  var client: LWAlamofireClient {
    var cfg = LWNetworkConfig()
    cfg.middlewares.append(LWCacheMiddleware(ttl: 5.0))
    return LWAlamofireClient(config: cfg, interceptor: LWAuthInterceptor(), monitors: [])
  }
  var body: some View {
    VStack(spacing: 12) {
      Text(out).frame(maxWidth: .infinity, alignment: .leading).padding().background(Color(.secondarySystemBackground)).cornerRadius(8)
      HStack {
        Button("GET /v1/cache?i=1") { Task { await hit(1) } }
        Button("GET /v1/cache?i=2") { Task { await hit(2) } }
      }.buttonStyle(LWProminentButtonStyle())
    }.padding()
  }
  func hit(_ i: Int) async {
    struct R:Decodable { let value:String; let ts:Int }
    let ep = LWAPI(env:.prod, path:"/v1/cache?i=\(i)", method:.get, task:.requestParameters(["foo":"bar"], encoding: URLEncoding.queryString), headers: [:], requiresAuth: false)
    do { let r:R = try await client.request(ep, as: R.self); out = "i=\(i) value=\(r.value) ts=\(r.ts) (repeat within 5s -> cached)" } catch { out = "Error: \(error)" }
  }
}
