
import SwiftUI
import LWNetworkKit

struct SSEDemo: View {
  @State private var log = ""
  @State private var es: LWEventSource? = nil

  var body: some View {
    VStack(spacing: 12) {
      ScrollView {
        Text(log).frame(maxWidth: .infinity, alignment: .leading)
      }.frame(height: 240)
      HStack {
        Button("Connect") { connect() }
        Button("Close") { close() }
      }.buttonStyle(LWProminentButtonStyle())
    }
    .padding()
  }

  private func connect() {
    let url = URL(string: "https://demo.local/v1/stream")!
    let source = LWEventSource(url: url) { ev in
      DispatchQueue.main.async {
        self.log += "[\(ev.event)] \(ev.data)\n"
      }
    }
    self.es = source
    source.connect()
  }

  private func close() {
    es?.close()
    es = nil
  }
}
