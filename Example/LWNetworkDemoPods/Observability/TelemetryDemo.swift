import SwiftUI
import LWNetworkKit

struct TelemetryDemo: View {
  @State private var out = "Tap to see headers injected"
  var client: LWAlamofireClient {
    var cfg = LWNetworkConfig()
    cfg.middlewares.append(LWTelemetryMiddleware(traceKey: "X-Trace-Id", sessionKey: "X-Session-Id", sessionProvider: { "demo-session" }))
    return LWAlamofireClient(config: cfg, interceptor: LWAuthInterceptor(), monitors: [])
  }
  var body: some View {
    VStack(spacing: 12) {
      Text(out).frame(maxWidth: .infinity, alignment: .leading).padding().background(Color(.secondarySystemBackground)).cornerRadius(8)
      Button("GET /v1/telemetry") { Task { await run() } }.buttonStyle(LWProminentButtonStyle())
    }.padding()
  }
  func run() async {
    struct R:Decodable { let headers: [String:String] }
    let ep = LWAPI(env:.prod, path:"/v1/telemetry", method:.get, requiresAuth: false)
    do { let r:R = try await client.request(ep, as: R.self); out = "Injected: trace=\(r.headers["X-Trace-Id"] ?? "-"), session=\(r.headers["X-Session-Id"] ?? "-")" } catch { out = "Error: \(error)" }
  }
}
