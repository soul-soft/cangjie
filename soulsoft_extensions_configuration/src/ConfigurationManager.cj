package soulsoft_extensions_configuration

import std.reflect.*
import std.collection.*

public class ConfigurationManager <: IConfigurationManager {
    private let _properties = HashMap<String, Any>()
    private let _sources = ArrayList<IConfigurationSource>()
    private let _providers = ArrayList<IConfigurationProvider>()

    public init() {
        
    }

    public prop sources: List<IConfigurationSource> {
        get() {
            _sources
        }
    }

    public prop providers: Collection<IConfigurationProvider> {
        get() {
            _providers
        }
    }

    public prop properties: HashMap<String, Any> {
        get() {
            _properties
        }
    }

    public operator func [](key: String): ?String {
        return getConfiguration(this, key)
    }

    public operator func [](key: String, value!: ?String): Unit {
        setConfiguration(this, key, value)
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

    public func add(source: IConfigurationSource): IConfigurationBuilder {
        let provider = source.build(this)
        provider.load()
        _sources.add(source)
        _providers.add(provider)
        return this
    }

    public func build(): IConfiguration {
        return this
    }
}

