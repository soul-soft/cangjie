package soulsoft_identity_server.hosting

import soulsoft_asp_http.*
import stdx.serialization.serialization.*
import soulsoft_identity_server.constants.*

public abstract class EndpointHandler <: IEndpointHandler {
    protected func methodNotAllowed() {
        return StatusEndpointResult(HttpStatusCode.MethodNotAllowed)
    }

    protected func json<T>(data: Serializable<T>) {
        return JsonEndpointResult<T>(data)
    }

    protected func json(json: String) {
        return ContentEndpointResult(json, "application/json;charset=utf-8")
    }

    protected func error(error: String, errorDescription: String) {
        return json(InvalidResult(error, errorDescription))
    }
}
