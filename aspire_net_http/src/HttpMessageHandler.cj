package aspire_net_http

public interface IHttpMessageHandler {
    func send(request: HttpRequestMessage, next: DelegatingHandler): HttpResponseMessage
}
