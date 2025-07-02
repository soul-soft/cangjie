package aspire_identity_server.hosting

import aspire_web_http.*
import stdx.encoding.json.ToJson
import stdx.serialization.serialization.*

public class JsonEndpointResult<T> <: IEndpointResult {
    public JsonEndpointResult(let data: Serializable<T>) {
    }

    public func execute(context: HttpContext) {
        context.response.write(data.serialize().toJson().toJsonString())
    }
}
