package soulsoft_net_http

import stdx.net.http.Client

public interface IHttpClientFactory {
    func create(name: String): HttpClient
}
