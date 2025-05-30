package soulsoft_asp_hosting

import std.collection.*

public class WebHostBuilder <: IHostBuilder {
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

    public func build() {
        let lifetime = HostLifetime()
        let webHostEnvironment = WebHostEnvironment(_configuration["webRootPath"] ?? "wwwroot", _environment)
        _services.addSingleton<IHostEnvironment>(_environment)
        _services.addSingleton<IWebHostEnvironment>(webHostEnvironment)
        _services.addSingleton<ILoggerFactory>(_logging.build())
        _services.addSingleton<IConfiguration>(_configuration.build())
        _services.addSingleton<IHostLifetime>(lifetime)
        let services = _services.build()
        WebHost(services, lifetime)
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

    public prop properties: HashMap<String, Any> {
        get() {
            _properties
        }
    }

    public prop environment: IHostEnvironment {
        get() {
            _environment
        }
    }

    public prop configuration: ConfigurationManager {
        get() {
            _configuration
        }
    }
}
