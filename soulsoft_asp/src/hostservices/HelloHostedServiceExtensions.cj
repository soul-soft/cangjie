package soulsoft_asp.hostservices

import soulsoft_extensions_hosting.HostedServiceExtensions
import soulsoft_extensions_options.*
import soulsoft_extensions_injection.*

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