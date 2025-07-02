package aspire_web_routing

import std.collection.*

public interface IHttpMethodMetadata {
    prop httpMethods: ReadOnlyList<String>
}

public class HttpMethodMetadata <: IHttpMethodMetadata {
    private let _httpMethods: ArrayList<String>

    public init(httpMethods: Array<String>) {
        _httpMethods = ArrayList(httpMethods)
    }

    public prop httpMethods: ReadOnlyList<String> {
        get() {
            _httpMethods
        }
    }
}
