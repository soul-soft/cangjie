package aspire_web_http

import std.io.*
import std.collection.*
import stdx.encoding.url.{URL, Form}
import stdx.net.http.{HttpHeaders, Protocol}

public abstract class HttpRequest {
    @Deprecated
    public prop url: URL
    public prop body: InputStream
    public prop bodySize: ?Int64
    public prop close: Bool
    public prop form: Form
    public prop host: HostString
    public prop isHttps: Bool
    public prop path: PathString
    public prop scheme: String
    public prop queryForm: Form
    public prop queryString: QueryString
    public prop headers: HttpHeaders
    public prop method: String
    public prop readTimeout: ?Duration
    public prop remoteAddr: String
    public prop trailers: HttpHeaders
    public prop version: Protocol
    public prop writeTimeout: ?Duration
    public mut prop routeValues: RouteValues
    public func getDisplayUrl(): String
}
