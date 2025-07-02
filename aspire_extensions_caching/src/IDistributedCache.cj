package aspire_extensions_caching

public interface IDistributedCache <: Resource {
    func get(key: String): ?Array<Byte>
    func set(key: String, value: Array<Byte>, expire: Duration): Unit
    func refresh(key: String): Unit
    func remove(key: String): Unit

    func getString(key: String): ?String {
        if (let Some(value) <- get(key)) {
            return String.fromUtf8(value)
        }
        return None
    }

    func setString(key: String, value: String, expire: Duration): Unit {
        set(key, value.toArray(), expire)
    }
}
