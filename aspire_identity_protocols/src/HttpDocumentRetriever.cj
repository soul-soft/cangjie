package aspire_identity_protocols

import aspire_net_http.*
import stdx.encoding.url.*

public class HttpDocumentRetriever <: IDocumentRetriever {
    private let _requireHttps: Bool
    private var _httpClient: ?HttpClient = None
    private static let _defaultHttpClient = HttpClient()

    public init(requireHttps!: Bool = true) {
        _requireHttps = requireHttps
    }

    public init(httpClient: HttpClient, requireHttps!: Bool = true) {
        _httpClient = httpClient
        _requireHttps = requireHttps
    }

    public func getDocument(address: String): String {
        if (_requireHttps && !Utility.isHttps(address)) {
            throw UnsupportedException("The address specified '${address}' is not valid as per HTTPS scheme. Please specify an https address for security reasons. If you want to test with http address, set the RequireHttps property  on IDocumentRetriever to false.")
        }
        let httpClient = getHttpClient()
        let response = httpClient.get(URL.parse(address))
        return  response.content.readAsString()
    }

    private func getHttpClient() {
        if (let Some(httpClient) <- _httpClient) {
            return httpClient
        }
        return _defaultHttpClient
    }

    public prop requireHttps: Bool {
        get() {
            _requireHttps
        }
    }
}
