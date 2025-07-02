package aspire_extensions_configuration


import std.env.*
import std.collection.*

class EnvVarsConfigurationProvider <: ConfigurationProvider {
    private let _prefix: String

    init(prefix: String) {
        _prefix = prefix
    }

    public override func load() {
        let prefix = "${_prefix.toAsciiLower()}_"
        for ((key, value) in getVariables()) {
            var name = key.toAsciiLower()
            if (!name.startsWith(prefix)) {
                continue
            }
            name = name.removePrefix(prefix)
            name = camelCase(name, '_')
            data.add(name, value)
        }
    }
}

class EnvVarsConfigurationSource <: IConfigurationSource {
    private let _prefix: String

    init(prefix: String) {
        _prefix = prefix
    }

    public func build(_: IConfigurationBuilder): IConfigurationProvider {
        let provider = EnvVarsConfigurationProvider(_prefix)
        return provider
    }
}

extend ConfigurationManager {
    public func addEnvVars(prefix: String): IConfigurationBuilder {
        add(EnvVarsConfigurationSource(prefix))
        return this
    }
}
