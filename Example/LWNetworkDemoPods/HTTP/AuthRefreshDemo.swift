import SwiftUI
import LWNetworkKit
struct AuthRefreshDemo: View {
  @State private var out = "Tap to run"; let client = LWAlamofireClient(config: LWNetworkConfig(), interceptor: LWAuthInterceptor(), monitors: [])
  var body: some View { VStack(spacing:12){ Text(out).frame(maxWidth:.infinity, alignment:.leading).padding().background(Color(.secondarySystemBackground)).cornerRadius(8); Button("GET /v1/me 401→refresh→retry") { Task { await run() } }.buttonStyle(LWProminentButtonStyle()) }.padding() }
  func run() async { struct Me:Decodable{ let id:String; let name:String }; let ep = LWAPI(env:.prod, path:"/v1/me?force401=1", method:.get); do { let me:Me = try await client.request(ep, as: Me.self); out = "OK id=\(me.id) name=\(me.name)" } catch { out = "Error: \(error)" } }
}
