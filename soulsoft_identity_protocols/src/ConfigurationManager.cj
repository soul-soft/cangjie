package soulsoft_identity_protocols

import std.sync.*

public class ConfigurationManager<T> <: IConfigurationManager<T> {
    private let _lock = Mutex()
    private let _address: String
    private var _currentConfiguration: ?T = None
    private let _documentRetriever: IDocumentRetriever
    private let _configurationRetriever: IConfigurationRetriever<T>

    public init(address: String, documentRetriever: IDocumentRetriever,
        configurationRetriever: IConfigurationRetriever<T>) {
        _address = address
        _documentRetriever = documentRetriever
        _configurationRetriever = configurationRetriever
    }

    public func refresh(): Unit {
        UnsupportedException()
    }

    public func getConfiguration(): T {
        if (let Some(configuration) <- _currentConfiguration) {
            return configuration
        } else {
            updateConfiguration()
            return _currentConfiguration.getOrThrow()
        }
    }

    private func updateConfiguration() {
        synchronized(_lock) {
            if (let Some(configuration) <- _currentConfiguration) {
                configuration
            }
            _currentConfiguration = _configurationRetriever.getConfiguration(_address, _documentRetriever)
        }
    }
}
