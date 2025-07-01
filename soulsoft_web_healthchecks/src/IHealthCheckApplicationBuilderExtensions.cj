package soulsoft_web_healthchecks

public interface IHealthCheckApplicationBuilderExtensions {
    func useHealthChecks(path: String): Unit
}

extend ApplicationBuilder <: IHealthCheckApplicationBuilderExtensions {
    public func useHealthChecks(path: String): Unit {
        let checkService = this.applicationServices.getOrThrow<IHealthCheckService>()
        use(HealthCheckMiddleware(path, checkService))
    }
}
