package aspire_extensions_hosting

public interface IHostedService {
    func start(): Unit
    func stop(): Unit
}
