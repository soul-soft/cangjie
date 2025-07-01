package soulsoft_identity_server.endpoints

import soulsoft_web_http.*

extend HttpRequest{
    public func hasFormContentType() {
        if (let Some(contextType) <- this.headers.getFirst("content-type")) {
            return contextType.equalsIgnoreAsciiCase("application/x-www-form-urlencoded")
        }
        return false
    }
}