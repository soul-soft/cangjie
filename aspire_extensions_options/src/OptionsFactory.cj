package aspire_extensions_options

import std.sync.*
import std.reflect.*
import std.collection.concurrent.*

public class OptionsFactory<TOptions> <: IOptionsFactory<TOptions> where TOptions <: Object {
    private let _lock = Mutex()
    private let _instances = ConcurrentHashMap<String, TOptions>()
    private let _configures: Array<IConfigureOptions<TOptions>>
    private let _configureAfters: Array<IConfigureAfterOptions<TOptions>>

    public init(configures: Array<IConfigureOptions<TOptions>>, configureAfters: Array<IConfigureAfterOptions<TOptions>>) {
        _configures = configures
        _configureAfters = configureAfters
    }

    public func create(name: String) {
        let instance = createInstance(name)
        return instance
    }

    private func configureOnce(name: String, instance: TOptions) {
        for (pattern in _configures) {
            pattern.configure(name, instance)
        }
        for (pattern in _configureAfters) {
            pattern.configureAfter(name, instance)
        }
    }

    private func createInstance(name: String) {
        if (_instances.contains(name)) {
            return _instances[name]
        } else {
            synchronized(_lock) {
                if (_instances.contains(name)) {
                    return _instances[name]
                }
                let instance = createInstance()
                configureOnce(name, instance)
                _instances[name] = instance
                return instance
            }
        }
    }

    private func createInstance(): TOptions {
        return (ClassTypeInfo.of<TOptions>().construct() as TOptions).getOrThrow()
    }
}
