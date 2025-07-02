package aspire_identity_protocols

public class StaticConfigurationManager<T> <: IConfigurationManager<T> {
    public StaticConfigurationManager(private let configuration: T) {
        
    }

    public func getConfiguration() {
        return configuration
    }

    public func refresh() {
        
    }
}