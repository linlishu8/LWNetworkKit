
import SwiftUI
import LWNetworkKit

struct TokenStoreDemo: View {
  @State private var out = "Tap to test token lifecycle"
  var body: some View {
    VStack(spacing: 12) {
      Text(out).frame(maxWidth: .infinity, alignment: .leading).padding().background(Color(.secondarySystemBackground)).cornerRadius(8)
      HStack {
        Button("Bootstrap") {
          Task { await LWTokenStore.shared.bootstrap(.init(access:"a1", refresh:"r1", expiry: Date().addingTimeInterval(5))); out = "Bootstrapped (expires in 5s)" }
        }
        Button("Refresh") {
          Task {
            await LWTokenStore.shared.setRefresher { rt in .init(access:"a2", refresh: rt, expiry: Date().addingTimeInterval(600)) }
            do { let token = try await LWTokenStore.shared.validAccessToken(); out = "Valid access = \(token.prefix(6))..." } catch { out = "Error: \(error)" }
          }
        }
      }.buttonStyle(LWProminentButtonStyle())
    }.padding()
  }
}
