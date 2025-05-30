package soulsoft_extensions_hosting

public interface HostedServiceExtensions {
    func addHostedService<THostedService>(): ServiceCollection where THostedService <: IHostedService & Object
}

extend ServiceCollection <: HostedServiceExtensions {
    public func addHostedService<THostedService>() where THostedService <: IHostedService & Object {
        addSingleton<IHostedService, THostedService>()
        return this
    }
}
