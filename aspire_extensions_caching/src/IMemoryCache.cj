package aspire_extensions_caching

public interface IMemoryCache <: Resource {
    func createEntry(key: Any): ICacheEntry
    func remove(key: Any): Unit
    func getValue(key: Any): ?Any
}
