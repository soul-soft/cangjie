package soulsoft_identity_tokens

import std.collection.*
import stdx.encoding.json.*
import stdx.serialization.serialization.*

public class JsonWebKey <: SecurityKey & Serializable<JsonWebKey> {
    public JsonWebKey(
        public var e!: ?String = None,
        public var k!: ?String = None,
        public var n!: ?String = None,
        public var d!: ?String = None,
        public var x!: ?String = None,
        public var y!: ?String = None,
        public var p!: ?String = None,
        public var q!: ?String = None,
        public var qi!: ?String = None,
        public var dp!: ?String = None,
        public var dq!: ?String = None,
        public var kid!: ?String = None,
        public var x5c!: ?String = None,
        public var x5t!: ?String = None,
        public var x5u!: ?String = None,
        public var crv!: ?String = None,
        public var kty!: ?String = None,
        public var use!: ?String = None,
        public var alg!: ?String = None,
        public var x5tS256!: ?String = None
    ) {
    }

    public static func create(json: String) {
        return deserialize(DataModel.fromJson(JsonValue.fromStr(json)))
    }

    public prop keyId: ?String {
        get() {
            kid
        }
    }

    public prop keySize: Int64 {
        get() {
            if (kty == "RSA" && let Some(data) <- n.flatMap {f => Base64UrlEncoder.decode(f)}) {
                return data.size * 8
            }

            if (kty == "EC" && let Some(data) <- x.flatMap {f => Base64UrlEncoder.decode(f)}) {
                return data.size * 8
            }

            if (kty == "oct" && let Some(data) <- k.flatMap {f => Base64UrlEncoder.decode(f)}) {
                return data.size * 8
            }

            return 0
        }
    }

    public func serialize(): DataModel {
        let dms = DataModelStruct()
        if (let Some(e) <- e) {
            dms.add(Field(JsonWebKeyParameterNames.e, DataModelString(e)))
        }
        if (let Some(k) <- k) {
            dms.add(Field(JsonWebKeyParameterNames.k, DataModelString(k)))
        }
        if (let Some(n) <- n) {
            dms.add(Field(JsonWebKeyParameterNames.n, DataModelString(n)))
        }
        if (let Some(d) <- d) {
            dms.add(Field(JsonWebKeyParameterNames.d, DataModelString(d)))
        }
        if (let Some(x) <- x) {
            dms.add(Field(JsonWebKeyParameterNames.x, DataModelString(x)))
        }
        if (let Some(y) <- y) {
            dms.add(Field(JsonWebKeyParameterNames.y, DataModelString(y)))
        }
        if (let Some(p) <- p) {
            dms.add(Field(JsonWebKeyParameterNames.p, DataModelString(p)))
        }
        if (let Some(q) <- q) {
            dms.add(Field(JsonWebKeyParameterNames.q, DataModelString(q)))
        }
        if (let Some(qi) <- qi) {
            dms.add(Field(JsonWebKeyParameterNames.qi, DataModelString(qi)))
        }
        if (let Some(dp) <- dp) {
            dms.add(Field(JsonWebKeyParameterNames.dp, DataModelString(dp)))
        }
        if (let Some(dq) <- dq) {
            dms.add(Field(JsonWebKeyParameterNames.dq, DataModelString(dq)))
        }
        if (let Some(kid) <- kid) {
            dms.add(Field(JsonWebKeyParameterNames.kid, DataModelString(kid)))
        }
        if (let Some(x5c) <- x5c) {
            dms.add(Field(JsonWebKeyParameterNames.x5c, DataModelString(x5c)))
        }
        if (let Some(x5t) <- x5t) {
            dms.add(Field(JsonWebKeyParameterNames.x5t, DataModelString(x5t)))
        }
        if (let Some(x5u) <- x5u) {
            dms.add(Field(JsonWebKeyParameterNames.x5u, DataModelString(x5u)))
        }
        if (let Some(crv) <- crv) {
            dms.add(Field(JsonWebKeyParameterNames.crv, DataModelString(crv)))
        }
        if (let Some(kty) <- kty) {
            dms.add(Field(JsonWebKeyParameterNames.kty, DataModelString(kty)))
        }
        if (let Some(use) <- use) {
            dms.add(Field(JsonWebKeyParameterNames.use, DataModelString(use)))
        }
        if (let Some(alg) <- alg) {
            dms.add(Field(JsonWebKeyParameterNames.alg, DataModelString(alg)))
        }
        if (let Some(x5tS256) <- x5tS256) {
            dms.add(Field(JsonWebKeyParameterNames.x5tS256, DataModelString(x5tS256)))
        }
        return dms
    }

    public static func deserialize(dm: DataModel): JsonWebKey {
        var dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let e = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.e))
        let k = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.k))
        let n = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.n))
        let d = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.d))
        let x = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.x))
        let y = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.y))
        let p = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.p))
        let q = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.q))
        let qi = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.qi))
        let dp = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.dp))
        let dq = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.dq))
        let kid = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.kid))
        let x5c = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.x5c))
        let x5t = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.x5t))
        let x5u = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.x5u))
        let crv = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.crv))
        let kty = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.kty))
        let use = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.use))
        let alg = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.alg))
        let x5tS256 = Option<String>.deserialize(dms.get(JsonWebKeyParameterNames.x5tS256))

        return JsonWebKey(e: e, k: k, n: n, d: d, x: x, y: y, p: p, q: q, qi: qi, dp: dp, dq: dq, kid: kid, x5c: x5c,
            x5t: x5t, x5u: x5u, crv: crv, kty: kty, use: use, alg: alg, x5tS256: x5tS256)
    }
}
