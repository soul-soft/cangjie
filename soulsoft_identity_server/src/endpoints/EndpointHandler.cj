package soulsoft_identity_server.endpoints

import soulsoft_asp_http.*
import stdx.serialization.serialization.*
import soulsoft_identity_server.hosting.*
import soulsoft_identity_server.constants.*

public abstract class EndpointHandler <: IEndpointHandler {
    protected func methodNotAllowed() {
        return StatusResult(HttpStatusCode.MethodNotAllowed)
    }

    protected func json<T>(data: Serializable<T>) {
        return JsonResult<T>(data)
    }

    protected func error(error: String, errorDescription: String) {
        return json(InvalidResult(error, errorDescription))
    }
}
