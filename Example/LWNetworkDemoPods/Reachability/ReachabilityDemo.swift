import SwiftUI
import LWNetworkKit

struct ReachabilityDemo: View {
  @State private var status = "Unknown"
  var body: some View {
    VStack(spacing: 12) {
      Text("Reachable: \(status)").frame(maxWidth: .infinity, alignment: .leading).padding().background(Color(.secondarySystemBackground)).cornerRadius(8)
      HStack {
        Button("Start monitor") { LWReachability.shared.start(); status = String(LWReachability.shared.isReachable) }
        Button("Stop") { LWReachability.shared.stop() }
        Button("Refresh") { status = String(LWReachability.shared.isReachable) }
      }.buttonStyle(LWProminentButtonStyle())
    }.padding()
  }
}
