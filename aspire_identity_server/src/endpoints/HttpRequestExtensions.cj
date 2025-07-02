package aspire_identity_server.endpoints

import aspire_web_http.*

extend HttpRequest{
    public func hasFormContentType() {
        if (let Some(contextType) <- this.headers.getFirst("content-type")) {
            return contextType.equalsIgnoreAsciiCase("application/x-www-form-urlencoded")
        }
        return false
    }
}