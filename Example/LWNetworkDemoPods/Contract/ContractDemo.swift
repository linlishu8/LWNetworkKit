import SwiftUI
import LWNetworkKit

struct ContractDemo: View {
  @State private var out = "Run quick contract checks"
  var client = LWAlamofireClient(config: LWNetworkConfig(), interceptor: LWAuthInterceptor(), monitors: [])
  var body: some View {
    VStack(spacing: 12) {
      Text(out).frame(maxWidth: .infinity, alignment: .leading).padding().background(Color(.secondarySystemBackground)).cornerRadius(8)
      Button("Run") { Task { await run() } }.buttonStyle(LWProminentButtonStyle())
    }.padding()
  }
  func run() async {
    do {
      struct Me:Decodable { let id:String; let name:String }
      struct R:Decodable { let value:Int }
      _ = try await client.request(LWAPI(env:.prod, path:"/v1/me", method:.get), as: Me.self)
      _ = try await client.request(LWAPI(env:.prod, path:"/v1/twice", method:.get, requiresAuth: false), as: R.self)
      out = "OK: /v1/me & /v1/twice shapes valid"
    } catch { out = "Contract failed: \(error)" }
  }
}
