import SwiftUI
struct PinningDemo: View { var body: some View { VStack(spacing:12){ Text("示例工程内置 pinning.json（目前为空）。生产使用时将公钥/证书(base64)写入，并在创建 Session 时配置 ServerTrustManager。此 Demo 以 mock 域名运行，无法真实校验证书，仅展示接入方式。").frame(maxWidth:.infinity, alignment:.leading) } .padding() } }
