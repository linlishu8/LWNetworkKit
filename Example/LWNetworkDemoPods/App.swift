import SwiftUI
import UIKit
import LWNetworkKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    LWBackgroundTransferClient.handleEvents(for: identifier, completionHandler: completionHandler)
  }
}

@main struct LWNetworkDemoPodsApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  init(){
    LWDemoURLProtocol.register()
    Task {
      await LWTokenStore.shared.setRefresher { rt in
        LWTokenStore.Token(access: "access-"+UUID().uuidString, refresh: rt, expiry: Date().addingTimeInterval(1800))
      }
      await LWTokenStore.shared.bootstrap(.init(access:"expired", refresh:"r-token", expiry: Date().addingTimeInterval(-10)))
    }
  }
  var body: some Scene { WindowGroup { DemoHomeView() } }
}
