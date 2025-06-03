package soulsoft_security_jwt

import std.collection.*
import stdx.encoding.json.*
import soulsoft_security_claims.*

class JsonConverter {
    private let _keys = HashSet<String>()
    private let _data = HashMap<String, Any>()

    public func toHashMap(str: String) {
        parse(JsonValue.fromStr(str))
        return _data
    }

    private func parse(jsonValue: JsonValue): Unit {
        match (jsonValue.kind()) {
            case JsonKind.JsArray => parseArray(jsonValue.asArray())
            case JsonKind.JsObject => parseObject(jsonValue.asObject())
            case _ => parseValue(jsonValue)
        }
    }

    private func parseObject(jsonObject: JsonObject) {
        for ((key, value) in jsonObject.getFields()) {
            _keys.add(key)
            parse(value)
            _keys.remove(key)
        }
    }

    private func parseArray(jsonArray: JsonArray) {
        for ((i, item) in jsonArray.getItems() |> enumerate) {
            parse(item)
        }
    }

    private func parseValue(jsonValue: JsonValue): Unit {
        match (jsonValue.kind()) {
            case JsonKind.JsBool => addValue(jsonValue.asBool().toString())
            case JsonKind.JsNull => addValue(jsonValue.asNull().toString())
            case JsonKind.JsString => addValue(jsonValue.asString().getValue())
            case JsonKind.JsInt => addValue(jsonValue.asInt().getValue().toString())
            case JsonKind.JsFloat => addValue(jsonValue.asFloat().getValue().toString())
            case _ => Exception()
        }
    }

    private func addValue(value: String) {
        let key = String.join(_keys |> collectArray, delimiter: ":")
        _data.add(key, value)
    }
}
