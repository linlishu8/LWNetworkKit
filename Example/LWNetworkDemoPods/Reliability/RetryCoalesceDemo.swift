import SwiftUI
import LWNetworkKit
struct RetryCoalesceDemo: View {
  @State private var out = "Tap to run"; var client: LWAlamofireClient { var cfg = LWNetworkConfig(); cfg.middlewares.append(LWTelemetryMiddleware(traceKey: "X-Trace-Id", sessionKey: "X-Session-Id", sessionProvider: { "demo" })); return LWAlamofireClient(config: cfg, interceptor: LWAuthInterceptor(), monitors: []) }
  var body: some View { VStack(spacing:12){ Text(out).frame(maxWidth:.infinity, alignment:.leading).padding().background(Color(.secondarySystemBackground)).cornerRadius(8); Button("GET /v1/twice (500→retry)") { Task { await run() } }.buttonStyle(LWProminentButtonStyle()) }.padding() }
  func run() async { struct R:Decodable{ let value:Int }; let ep = LWAPI(env:.prod, path:"/v1/twice", method:.get, requiresAuth: false); do { let r:R = try await client.request(ep, as: R.self); out = "OK value=\(r.value)" } catch { out = "Error: \(error)" } }
}
