import SwiftUI
import LWNetworkKit
struct OfflineQueueDemo: View {
  @State private var out = "Tap enqueue"; var body: some View { VStack(spacing:12){ Text(out).frame(maxWidth:.infinity, alignment:.leading).padding().background(Color(.secondarySystemBackground)).cornerRadius(8); HStack{ Button("Enqueue 3") { enqueue3() }; Button("Flush") { LWOfflineQueue.shared.flush(); out = "Flushed" } }.buttonStyle(LWProminentButtonStyle()) }.padding() }
  func enqueue3(){ for i in 0..<3 { let payload = try! JSONSerialization.data(withJSONObject: ["i":i]); LWOfflineQueue.shared.enqueue(.init(method:"POST", url:"https://demo.local/v1/offline", body:payload, priority: .normal)) } ; LWOfflineQueue.shared.start(); out = "Enqueued 3" }
}
