package aspire_net_http

import stdx.encoding.url.Form

public class FormUrlContent <: ByteArrayContent {
   
    public init(values: Iterable<(String, String)>) {
        super(serializeToByteArray(values))
        super.headers.add("Content-Type", "application/x-www-form-urlencoded")
    }

    private static func serializeToByteArray(values: Iterable<(String, String)>) {
        let form = Form()
        for ((name,value) in values) {
            form.add(name, value)
        }
        return form.toEncodeString().toArray()
    }
}
