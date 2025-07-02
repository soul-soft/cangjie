package aspire_extensions_configuration

import std.process.*
import std.collection.*

class MemoryConfigurationProvider <: ConfigurationProvider {
    private let _values: HashMap<String, String>

    init(values: HashMap<String, String>) {
        _values = values
    }

    public override func load() {
        for ((key, value) in _values) {
            data[key] = value
        }
    }
}

class MemoryConfigurationSource <: IConfigurationSource {
    private let _values: HashMap<String, String>
    
    init(values: HashMap<String, String>) {
        _values = values
    }

    public func build(_: IConfigurationBuilder): IConfigurationProvider {
        let provider = MemoryConfigurationProvider(_values)
        return provider
    }
}

extend ConfigurationManager {
    public func addMemory(values: HashMap<String, String>): IConfigurationBuilder {
        add(MemoryConfigurationSource(values))
        return this
    }
}
