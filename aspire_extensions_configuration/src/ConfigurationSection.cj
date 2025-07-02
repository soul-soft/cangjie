package aspire_extensions_configuration

import std.collection.*

class ConfigurationSection <: IConfigurationSection {
    private let _path: String
    private let _key: String
    private let _value: ?String
    private let _root: IConfigurationRoot

    init(path: String, key: String, value: ?String, root: IConfigurationRoot) {
        _path = path
        _key = key
        _value = value
        _root = root
    }

    public prop key: String {
        get() {
            _key
        }
    }

    public prop value: ?String {
        get() {
            _value
        }
    }

    public prop path: String {
        get() {
            _path
        }
    }

    public operator func [](key: String) {
        return _root["${_path}:${key}"]
    }

    public operator func [](key: String, value!: ?String) {
        _root["${_path}:${key}"] = value
    }

    public func getSection(key: String): IConfigurationSection {
        return ConfigurationSection("${_path}:${key}", key, this[key], _root)
    }

    public func getChildren(): Collection<IConfigurationSection> {
        let items = ArrayList<IConfigurationSection>()
        for (key in getChildKeys(_root, _path)) {
            let section = getSection(key)
            items.add(section)
        }
        return items |> collectArray
    }
}
