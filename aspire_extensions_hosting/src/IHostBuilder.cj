package aspire_extensions_hosting

import std.collection.*

public interface IHostBuilder {
    prop logging: LoggingBuilder
    prop services: ServiceCollection
    prop environment: IHostEnvironment
    prop properties: HashMap<String, Any>
    prop configuration: ConfigurationManager
}

public class HostBuilder <: IHostBuilder {
    private let _logging: LoggingBuilder
    private let _services: ServiceCollection
    private let _environment: IHostEnvironment
    private let _properties = HashMap<String, Any>()
    private let _configuration: ConfigurationManager

    init(logging: LoggingBuilder, environment: IHostEnvironment, configuration: ConfigurationManager) {
        _logging = logging
        _environment = environment
        _configuration = configuration
        _services = ServiceCollection()
    }

    public func build(): IHost {
        let lifetime = HostLifetime()
        _services.addSingleton<IHostEnvironment>(_environment)
        _services.addSingleton<ILoggerFactory>(_logging.build())
        _services.addSingleton<IConfiguration>(_configuration.build())
        _services.addSingleton<IHostLifetime>(lifetime)
        let services = _services.build()
        Host(services, lifetime)
    }

    public prop logging: LoggingBuilder {
        get() {
            _logging
        }
    }

    public prop services: ServiceCollection {
        get() {
            _services
        }
    }

    public prop environment: IHostEnvironment {
        get() {
            _environment
        }
    }

    public prop properties: HashMap<String, Any> {
        get() {
            _properties
        }
    }

    public prop configuration: ConfigurationManager {
        get() {
            _configuration
        }
    }

}
