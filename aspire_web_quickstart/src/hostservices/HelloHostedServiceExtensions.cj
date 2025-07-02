package aspire_web_quickstart.hostservices

import aspire_extensions_hosting.*
import aspire_extensions_options.*
import aspire_extensions_injection.*

public interface HelloHostedServiceExtensions {
    func addHelloHostedService(): ServiceCollection
    func addHelloHostedService(configureOptions: (HelloHostedServiceOptions) -> Unit): ServiceCollection
}

extend ServiceCollection <: HelloHostedServiceExtensions{
    
    public func addHelloHostedService(): ServiceCollection {
        addHelloHostedService({_=>})
    }

    public func addHelloHostedService(configureOptions: (HelloHostedServiceOptions) -> Unit): ServiceCollection {
        this.configure<HelloHostedServiceOptions>(configureOptions)
        this.addHostedService<HelloHostedService>()
    }
}