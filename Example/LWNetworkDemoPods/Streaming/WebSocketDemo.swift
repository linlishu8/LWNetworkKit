import SwiftUI
import LWNetworkKit

struct WebSocketDemo: View {
  @State private var log = ""
  @State private var socket: LWWebSocket? = nil
  var body: some View {
    VStack(spacing: 12) {
      ScrollView { Text(log).frame(maxWidth: .infinity, alignment: .leading) }.frame(height: 240)
      HStack {
        Button("Connect echo") {
          let url = URL(string: "wss://echo.websocket.events")!
          let ws = LWWebSocket(url: url); ws.connect(); socket = ws; log += "connecting...\n"
        }
        Button("Send 'hello'") { Task { try? await socket?.send("hello"); log += "sent: hello\n" } }
        Button("Close") { socket?.close(); log += "closed\n" }
      }.buttonStyle(LWProminentButtonStyle())
    }.padding()
  }
}
