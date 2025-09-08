import SwiftUI

struct Row: Identifiable { let id = UUID(); let title:String; let dest: AnyView }
struct DemoHomeView: View {
  var rows: [Row] = [
    Row(title:"Auth Refresh (401→refresh→retry)", dest: AnyView(AuthRefreshDemo())),
    Row(title:"Query Params", dest: AnyView(ParamsDemo())),
    Row(title:"Download / ETag", dest: AnyView(DownloadETagDemo())),
    Row(title:"Retry & Coalesce", dest: AnyView(RetryCoalesceDemo())),
    Row(title:"Cache TTL (In-memory)", dest: AnyView(CacheDemo())),
    Row(title:"Rate Limit / Circuit Breaker", dest: AnyView(LimiterBreakerDemo())),
    Row(title:"Background Transfer", dest: AnyView(BackgroundTransferDemo())),
    Row(title:"SSE Streaming", dest: AnyView(SSEDemo())),
    Row(title:"WebSocket Echo", dest: AnyView(WebSocketDemo())),
    Row(title:"Offline Queue", dest: AnyView(OfflineQueueDemo())),
    Row(title:"Reachability", dest: AnyView(ReachabilityDemo())),
    Row(title:"Pinning (setup sample)", dest: AnyView(PinningDemo())),
    Row(title:"Telemetry (headers)", dest: AnyView(TelemetryDemo())),
    Row(title:"Contract (Mock)", dest: AnyView(ContractDemo())),
  ]
  var body: some View {
    NavigationView {
      List(rows) { r in NavigationLink(r.title, destination: r.dest) }
      .navigationBarTitle("LWNetwork Demo (Pods)", displayMode: .inline)
    }
  }
}
