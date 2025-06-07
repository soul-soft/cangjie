package soulsoft_security_tokens_jwt

import std.collection.*
import stdx.encoding.json.*
import soulsoft_security_claims.*

class JsonUtilities {
    public static func toHashMap(str: String) {
        return toHashMap(JsonValue.fromStr(str).asObject())
    }

    private static func toJsonValue(value: Any): ?JsonValue {
        if (let data: String <- value) {
            return JsonString(data)
        } else if (let data: Int64 <- value) {
            return JsonFloat(data)
        } else if (let data: Bool <- value) {
            return JsonBool(data)
        }
        return None
    }

    public static func fromHashMap(hashMap: HashMap<String, Any>) {
        let jsonValue = JsonObject()
        for ((key, value) in hashMap) {
            if (let data: ArrayList<Any> <- value) {
                let jsonArray = JsonArray()
                for (pattern in data) {
                    if (let Some(jsonValue) <- toJsonValue(pattern)) {
                        jsonArray.add(jsonValue)
                    }
                }
                jsonValue.put(key, jsonArray)
            } else {
                if (let Some(data) <- toJsonValue(value)) {
                    jsonValue.put(key, data)
                }
            }
        }
        return jsonValue.toJsonString()
    }

    private static func toHashMap(jsonObject: JsonObject) {
        let data = HashMap<String, Any>()
        for ((key, value) in jsonObject.getFields()) {
            match (value.kind()) {
                case JsonKind.JsArray => data.add(key, parseArrayValue(value.asArray()))
                case _ =>
                    if (let Some(value) <- parseStringValue(value)) {
                        data.add(key, value)
                    }
            }
        }
        return data
    }

    private static func parseArrayValue(jsonArray: JsonArray) {
        let list = ArrayList<Any>()
        for (pattern in jsonArray.getItems()) {
            if (let Some(value) <- parseStringValue(pattern)) {
                list.add(value)
            }
        }
        return list
    }

    private static func parseStringValue(jsonValue: JsonValue): ?Any {
        return match (jsonValue.kind()) {
            case JsonKind.JsBool => jsonValue.asBool().getValue()
            case JsonKind.JsString => jsonValue.asString().getValue()
            case JsonKind.JsInt => jsonValue.asInt().getValue()
            case JsonKind.JsFloat => jsonValue.asFloat().getValue()
            case _ => None
        }
    }
}
