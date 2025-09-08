import SwiftUI
import LWNetworkKit
import Alamofire

struct ParamsDemo: View {
    @State private var out = "Tap to GET /v1/users/42"
    let client = LWAlamofireClient(
        config: LWNetworkConfig(),
        interceptor: LWAuthInterceptor(),
        monitors: []
    )

    var body: some View {
        VStack(spacing: 12) {
            Text(out)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            Button("GET with ?foo=bar") {
                Task { await run() }
            }
            .buttonStyle(LWProminentButtonStyle())
        }
        .padding()
    }

    func run() async {
        struct U: Decodable {
            let id: String
            let name: String
        }

        let ep = LWAPI(
            env: .prod,
            path: "/v1/users/42",
            method: .get,
            task: .requestParameters(["foo": "bar"], encoding: URLEncoding.queryString),
            headers: [:],
            requiresAuth: false
        )

        do {
            let u: U = try await client.request(ep, as: U.self)
            out = "User: \(u.id) \(u.name)"
        } catch {
            out = "Error: \(error)"
        }
    }
}
