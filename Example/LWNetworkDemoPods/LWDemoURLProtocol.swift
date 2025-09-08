
import Foundation
final class LWDemoURLProtocol: URLProtocol {
  override class func canInit(with request: URLRequest) -> Bool { request.url?.host == "demo.local" }
  override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
  override func startLoading() {
    guard let url = request.url else { return }
    let path = url.path; let method = request.httpMethod ?? "GET"; let key = method + " " + url.absoluteString + " body:\(request.httpBody?.count ?? 0)"; LWDemoURLProtocolState.shared.bump(key)
    DispatchQueue.global().asyncAfter(deadline: .now() + 0.03) { [weak self] in
      guard let self else { return }
      switch (path, method) {
      case ("/v1/me","GET"):
        if url.query?.contains("force401=1") == true && LWDemoURLProtocolState.shared.should401Once(for: url.absoluteString) { self.json(401, ["error":"unauthorized"]); return }
        self.json(200, ["id":"123","name":"LWUser"])
      case ("/v1/users/42","GET"):
        self.json(200, ["id":"42","name":"Douglas"])
      case ("/v1/file","GET"):
        let etag = LWDemoURLProtocolState.shared.etag()
        if request.value(forHTTPHeaderField:"If-None-Match") == etag { self.raw(304, Data(), headers:["Etag": etag, "Content-Length":"0"]); return }
        let data = Data(repeating: 0xAB, count: 1024)
        self.raw(200, try! JSONSerialization.data(withJSONObject: ["len": data.count]), headers:["Etag": etag, "Content-Type":"application/json"])
      case ("/v1/bigfile","GET"):
        // Simulate big download using 'size' query (default 5MB)
        let size = (URLComponents(url: url, resolvingAgainstBaseURL: false)?
          .queryItems?.first(where: { $0.name == "size" })?.value).flatMap { Int($0) } ?? 5*1024*1024
        let chunk = Data(repeating: 0xCD, count: 64*1024)
        let h = ["Content-Type":"application/octet-stream", "Content-Length":"\(size)"]
        self.client?.urlProtocol(self, didReceive: HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: h)!, cacheStoragePolicy: .notAllowed)
        var sent = 0
        while sent < size {
          let toSend = min(chunk.count, size - sent)
          self.client?.urlProtocol(self, didLoad: chunk.prefix(toSend))
          sent += toSend
          usleep(2000) // stream a bit
        }
        self.client?.urlProtocolDidFinishLoading(self)
      case ("/v1/twice","GET"):
        let c = LWDemoURLProtocolState.shared.hits(for: key)
        if c == 1 { self.json(500, ["error":"server"]); } else { self.json(200, ["value": 2]) }
      case ("/v1/limiter","GET"):
        if request.value(forHTTPHeaderField:"X-CB-Open") == "1" { self.json(503, ["status":"circuit open"]); return }
        self.json(200, ["status":"ok \(Int.random(in: 1...999))"])
      case ("/v1/offline","POST"):
        if Int.random(in: 0...2) == 0 { self.json(500, ["status":"flaky"]) } else { self.json(200, ["status":"stored"]) }
      case ("/v1/stream","GET"):
        let h = ["Content-Type":"text/event-stream"]
        self.client?.urlProtocol(self, didReceive: HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: h)!, cacheStoragePolicy: .notAllowed)
        let lines = ["event: message\n","data: hello\n\n","event: message\n","data: world\n\n"]
        for l in lines { self.client?.urlProtocol(self, didLoad: l.data(using: .utf8)!) }
        self.client?.urlProtocolDidFinishLoading(self)
      case ("/v1/cache","GET"):
        let now = Int(Date().timeIntervalSince1970)
        let i = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first(where: { $0.name == "i" })?.value ?? "0"
        self.json(200, ["value": i, "ts": now])
      case ("/v1/telemetry","GET"):
        var headers: [String:String] = [:]
        if let all = request.allHTTPHeaderFields { headers = all }
        self.json(200, ["headers": headers])
      default: self.json(404, ["error":"not found"])
      }
    }
  }
  override func stopLoading() {}
  private func json(_ status:Int, _ body:[String:Any]){ let d = try! JSONSerialization.data(withJSONObject: body); let resp = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: "HTTP/1.1", headerFields: ["Content-Type":"application/json"])!; client?.urlProtocol(self, didReceive: resp, cacheStoragePolicy: .notAllowed); client?.urlProtocol(self, didLoad: d); client?.urlProtocolDidFinishLoading(self) }
  private func raw(_ status:Int, _ body:Data, headers:[String:String]){ let resp = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: "HTTP/1.1", headerFields: headers)!; client?.urlProtocol(self, didReceive: resp, cacheStoragePolicy: .notAllowed); client?.urlProtocol(self, didLoad: body); client?.urlProtocolDidFinishLoading(self) }
  static func register(){ if LWDemoURLProtocolState.shared.registered { return } ; URLProtocol.registerClass(LWDemoURLProtocol.self); LWDemoURLProtocolState.shared.setRegistered() }
}
