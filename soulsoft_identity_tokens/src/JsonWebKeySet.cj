package soulsoft_identity_tokens

import std.collection.*
import stdx.serialization.serialization.*

public class JsonWebKeySet <: Serializable<JsonWebKeySet> {
    private let _keys = ArrayList<JsonWebKey>()

    public init() {
    }

    public JsonWebKeySet(keys: Collection<JsonWebKey>) {
        _keys.add(all: keys)
    }

    public prop keys: List<JsonWebKey> {
        get() {
            _keys
        }
    }

    public func serialize(): DataModel {
        let dms = DataModelStruct()
        dms.add(Field("keys", DataModelSeq(keys |> map {f => f.serialize()} |> collectArrayList)))
        return dms
    }

    public static func deserialize(dm: DataModel): JsonWebKeySet {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let jwks = JsonWebKeySet()
        if (let seq: DataModelSeq <- dms.get("keys")) {
            for (item in seq.getItems()) {
                jwks.keys.add(JsonWebKey.deserialize(item))
            }
        }
        return jwks
    }
}
