package aspire_web_hosting

import std.env.*
import std.sync.*
import std.collection.*

public class WebHost <: ApplicationBuilder & IHost {
    private let _logger: ILogger
    private let _counter = SyncCounter(1)
    private let _lifetime: HostLifetime
    private let _services: IServiceProvider
    private let _environment: IHostEnvironment
    private let _configuration: IConfiguration
    private let _properties = HashMap<String, Any>()
    private let _hostedServices: Array<IHostedService>
    private let _middlewares = ArrayList<(RequestDelegate) -> RequestDelegate>()

    init(services: IServiceProvider, lifetime: HostLifetime) {
        _services = services
        _lifetime = lifetime
        _environment = _services.getOrThrow<IHostEnvironment>()
        _configuration = _services.getOrThrow<IConfiguration>()
        _hostedServices = _services.getAll<IHostedService>()
        _logger = services.getOrThrow<ILoggerFactory>().createLogger("aspire.hosting.lifetime")
    }

    public func run() {
        run("http://127.0.0.1:5000")
    }

    public func run(urls: Array<String>) {
        start(urls)
        stop()
    }

    public func start() {
        start("http://127.0.0.1:5000")
    }

    public func start(urls: Array<String>) {
        logging(urls)
        startHostedServices()
        _lifetime.started()
        let server = HttpServer(build(), _services)
        let task = spawn { server.listen(urls) }
        atExit{
            stop()
        }
        _counter.waitUntilZero()
        return
    }

    public func stop() {        
        _lifetime.stopping()
        stopHostedServices()
        _lifetime.stopped()
        _counter.dec()
    }

    private func startHostedServices() {
        for (pattern in _hostedServices) {
            pattern.start()
        }
    }

    private func stopHostedServices() {
        for (pattern in _hostedServices) {
            try {
                pattern.stop()
            } catch (_: Exception) {
            }
        }
    }

    public func use(middleware:(RequestDelegate)->RequestDelegate) {
        _middlewares.add(middleware)
        return this
    }

    public prop logger: ILogger {
        get() {
            _logger
        }
    }

    public prop lifetime: IHostLifetime {
        get() {
            _lifetime
        }
    }

    public prop services: IServiceProvider {
        get() {
            _services
        }
    }

    public prop applicationServices: IServiceProvider {
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

    public prop configuration: IConfiguration {
        get() {
            _configuration
        }
    }

    public func build(): RequestDelegate {
        var app: RequestDelegate = {
            context => context.response.status(404)
        }
        var index = _middlewares.size - 1;
        while (index >= 0) {
            let middleware = _middlewares[index]
            app = middleware(app)
            index--
        }
        return app
    }
    
    public static func createBuilder(args: Array<String>) {
        let environment = configureEnvironment(args)
        let configuration = configureConfiguration(args, environment)
        let logging = configureLogging(configuration.getSection("logging"))
        return WebHostBuilder(logging, environment, configuration)
    }

    private static func configureEnvironment(args: Array<String>): IHostEnvironment {
        let configuration = ConfigurationManager()
        configuration.addEnvVars("asp")
        configuration.addArgVars(args)
        let environmentName = configuration["environment"] ?? "prod"
        let contentRootPath = configuration["contentRootPath"] ?? getWorkingDirectory().toString()
        let applicationName = configuration["applicationName"] ?? String.empty
        return HostEnvironment(environmentName, contentRootPath, applicationName)
    }

    private static func configureConfiguration(args: Array<String>, environment: IHostEnvironment) {
        let configuration = ConfigurationManager()
        configuration.addEnvVars("asp")
        configuration.addArgVars(args)
        configuration.addJsonFile("./appsettings.json", optional: true)
        configuration.addJsonFile("./appsettings.${environment.environmentName}.json", optional: true)
        return configuration
    }

    private static func configureLogging(configuration: IConfiguration) {
        let logging = LoggingBuilder()
        logging.addConsole()
        logging.addConfiguration(configuration)
    }

    private func logging(urls: Array<String>) {
        let loggerFactory = _services.getOrThrow<ILoggerFactory>()
        let logger = loggerFactory.createLogger("asp.hosting.lifetime")
        for (pattern in urls) {
            logger.info("Now listening on: ${pattern}")
        }
        logger.info("Hosting environment: ${_environment.environmentName}")
        logger.info("Content root path: ${_environment.contentRootPath}")
        logger.info("Application started. Press Ctrl+C to shut down.")
    }
}
