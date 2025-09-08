import SwiftUI
import LWNetworkKit

final class BGDelegateProxy: NSObject, LWBackgroundTransferDelegate, ObservableObject {
  @Published var progressText = "Idle"
  @Published var lastFileURL: URL? = nil
  func bgProgress(id: String, bytesWritten: Int64, totalBytes: Int64) {
    DispatchQueue.main.async {
      let pct = totalBytes > 0 ? Int((Double(bytesWritten) / Double(totalBytes)) * 100) : 0
      self.progressText = "Downloading [\(id)] \(bytesWritten)/\(totalBytes) (\(pct)%)"
    }
  }
  func bgFinished(id: String, fileURL: URL) {
    DispatchQueue.main.async { self.progressText = "Finished [\(id)] -> \(fileURL.lastPathComponent)"; self.lastFileURL = fileURL }
  }
  func bgFailed(id: String, error: Error) {
    DispatchQueue.main.async { self.progressText = "Failed [\(id)] : \(error.localizedDescription)" }
  }
}

struct BackgroundTransferDemo: View {
  @StateObject private var proxy = BGDelegateProxy()
  var body: some View {
    VStack(spacing: 12) {
      Text(proxy.progressText).frame(maxWidth: .infinity, alignment: .leading).padding().background(Color(.secondarySystemBackground)).cornerRadius(8)
      HStack {
        Button("Start 5MB") {
          LWBackgroundTransferClient.shared.delegate = proxy
          let url = URL(string: "https://demo.local/v1/bigfile?size=5242880")!
          _ = LWBackgroundTransferClient.shared.download(id: "file-5m", from: url)
        }
        Button("Cancel") { LWBackgroundTransferClient.shared.cancel(id: "file-5m") }
      }.buttonStyle(LWProminentButtonStyle())
      if let f = proxy.lastFileURL { Text("Temp file: \(f.path)").font(.footnote).foregroundColor(.secondary) }
    }.padding()
  }
}
