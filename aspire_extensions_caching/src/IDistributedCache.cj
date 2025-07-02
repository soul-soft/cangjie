package aspire_extensions_caching

public interface IDistributedCache {
    func get(key: String): ?Array<Byte>
    func refresh(key: String): Unit
    func remove(key: String): Unit
    func set(key: String, value: Array<Byte>, options: DistributedCacheEntryOptions): Unit

    func getString(key: String): ?String {
        if (let Some(value) <- get(key)) {
            return String.fromUtf8(value)
        }
        return None
    }

    func setString(key: String, value: String, options: DistributedCacheEntryOptions): Unit {
        set(key, value.toArray(), options)
    }
}
