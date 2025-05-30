package soulsoft_extensions_configuration

import std.collection.*

public abstract class ConfigurationProvider <: IConfigurationProvider {
    private let _data = HashMap<String, ?String>()

    protected prop data: HashMap<String, ?String> {
        get() {
            _data
        }
    }

    public open func get(key: String): ?String {
        if (_data.contains(key)) {
            return _data[key]
        }
        return None
    }

    public open func set(key: String, value: ?String): Unit {
        _data[key] = value
    }

    public open func getChildKeys(earlierKeys: Iterable<String>, parentPath: ?String): Iterable<String> {
        let results = HashSet<String>()
        if (let Some(parentPath) <- parentPath) {
            for (pattern in data.keys()) {
                if (pattern.size > parentPath.size && pattern.startsWith(parentPath) && pattern[parentPath.size..parentPath.size + 1] == ":") {
                    results.add(segment(pattern, parentPath.size + 1));   
                }
            }
        } else {
            for (pattern in data.keys()) {
                results.add(segment(pattern, 0))
            }
        }
        results.add(all: earlierKeys |> collectArray)
        return results
    }

    private static func segment(key: String, prefixLength: Int64): String {
        if (let Some(index) <- key.indexOf(':', prefixLength)) {
            return key[prefixLength..index]
        }
        return key[prefixLength..]
    }

    public open func load(): Unit {

    }
}
