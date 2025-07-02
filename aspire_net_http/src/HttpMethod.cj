package aspire_net_http

public class HttpMethod <: ToString {
    private let _method: String

    public init(method: String) {
        _method = method
    }

    public static let get = HttpMethod("GET")
    public static let post = HttpMethod("POST")
    public static let put = HttpMethod("PUT")
    public static let delete = HttpMethod("DELETE")
    public static let patch = HttpMethod("PATCH")
    public static let head = HttpMethod("HEAD")
    public static let options = HttpMethod("OPTIONS")
    public static let trace = HttpMethod("TRACE")
    public static let connect = HttpMethod("CONNECT")

    public func toString() {
        return _method.toAsciiUpper()
    }
}
