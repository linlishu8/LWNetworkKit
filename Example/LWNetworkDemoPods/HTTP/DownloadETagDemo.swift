import SwiftUI
import LWNetworkKit
struct DownloadETagDemo: View {
  @State private var out = "Tap to run"; var client: LWAlamofireClient { var cfg = LWNetworkConfig(); cfg.useETagCaching = true; return LWAlamofireClient(config: cfg, interceptor: LWAuthInterceptor(), monitors: []) }
  var body: some View { VStack(spacing:12){ Text(out).frame(maxWidth:.infinity, alignment:.leading).padding().background(Color(.secondarySystemBackground)).cornerRadius(8); Button("GET /v1/file (ETag)") { Task { await run() } }.buttonStyle(LWProminentButtonStyle()) }.padding() }
  func run() async { struct F:Decodable{ let len:Int }; let ep = LWAPI(env:.prod, path:"/v1/file", method:.get, requiresAuth: false); do { let f:F = try await client.request(ep, as: F.self); out = "OK len=\(f.len)" } catch { out = "Error: \(error)" } }
}
