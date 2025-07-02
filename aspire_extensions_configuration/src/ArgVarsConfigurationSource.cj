package aspire_extensions_configuration

import std.process.*
import std.collection.*

class ArgVarsConfigurationProvider <: ConfigurationProvider {
    private let _args: Array<String>
    
    init(args: Array<String>) {
        _args = args
    }
    
    public override func load() {
        for (item in _args) {
            let entry = item.split('=', 2)
            if (entry.size < 2) {
                continue
            }
            let key = camelCase(entry[0], "-")
            let value = entry[1].trimEnd().trimStart()
            data.add(key, value)
        }
    }
}

class ArgVarsConfigurationSource <: IConfigurationSource {
    private let _args: Array<String>
   
    init(args: Array<String>) {
        _args = args
    }

    public func build(_: IConfigurationBuilder): IConfigurationProvider {
        let provider = ArgVarsConfigurationProvider(_args)
        return provider
    }
}

extend ConfigurationManager {
    public func addArgVars(args: Array<String>): IConfigurationBuilder {
        add(ArgVarsConfigurationSource(args))
        return this
    }
}
