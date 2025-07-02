package aspire_extensions_configuration

import std.fs.*
import std.io.*
import stdx.encoding.json.*
import std.collection.*

class JsonConfigurationProvider <: ConfigurationProvider {
    private let _json: String
    private let _keys = HashSet<String>()

    init(json: String) {
        _json = json
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
            _keys.add("${i}")
            parse(item)
            _keys.remove("${i}")
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
        data.add(key, value)
    }

    public override func load() {
        let jsonValue = JsonValue.fromStr(_json)
        parse(jsonValue)
    }
}

class JsonConfigurationSource <: IConfigurationSource {
    private let _json: String

    init(json: String) {
        _json = json
    }

    public func build(_: IConfigurationBuilder): IConfigurationProvider {
        let provider = JsonConfigurationProvider(_json)
        return provider
    }
}

extend ConfigurationManager {
    public func addJsonStream(stream: IOStream): IConfigurationBuilder {
        let sr = StringReader(stream)
        let json = sr.readToEnd()
        add(JsonConfigurationSource(json))
        return this
    }

    public func addJsonFile(path: String, optional!: Bool = true): IConfigurationBuilder {
        if (optional && !exists(path)) {
            return this
        }
        try (file = File(path, OpenMode.Read)) {
            addJsonStream(file)
        }
        return this
    }
}
