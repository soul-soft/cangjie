package soulsoft_identity_server.endpoints

import soulsoft_asp_http.*
import stdx.encoding.json.ToJson
import stdx.serialization.serialization.*

import soulsoft_identity_server.hosting.*

public class JsonResult<T> <: IEndpointResult {
    public JsonResult(let data: Serializable<T>) {
        
    }

    public func execute(context: HttpContext) {
        context.response.write(data.serialize().toJson().toJsonString())
    }
}
