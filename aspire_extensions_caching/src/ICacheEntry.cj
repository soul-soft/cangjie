package aspire_extensions_caching

public interface ICacheEntry {
    prop key: Any
    prop value: Any
    prop expiration: Duration
}
