package soulsoft_extensions_configuration

import std.collection.*

public class ConfigurationRoot <: IConfigurationRoot {
    private let _providers: List<IConfigurationProvider>

    public init(providers: List<IConfigurationProvider>) {
        _providers = providers
    }

    public prop providers: List<IConfigurationProvider> {
        get() {
            _providers
        }
    }

    public operator func [](key: String): ?String {
        return getConfiguration(_providers, key)
    }

    public operator func [](key: String, value!: ?String): Unit {
        setConfiguration(_providers, key, value)
    }

    public func getSection(key: String): IConfigurationSection {
        return ConfigurationSection(key, key, this[key], this)
    }

    public func getChildren(): Collection<IConfigurationSection> {
        let items = ArrayList<IConfigurationSection>()
        for (key in getChildKeys(this, None)) {
            let section = getSection(key)
            items.add(section)
        }
        return items
    }

    static func getConfiguration(providers: List<IConfigurationProvider>, key: String): ?String {
        var index = providers.size - 1
        while (index >= 0) {
            let provider = providers[index]
            if (let Some(value) <- provider.get(key)) {
                return value
            }
            index--
        }
        return None
    }

    static func setConfiguration(providers: Collection<IConfigurationProvider>, key: String, value: ?String): ?String {
        for (pattern in providers) {
            pattern.set(key, value)
        }
        return None
    }
}
