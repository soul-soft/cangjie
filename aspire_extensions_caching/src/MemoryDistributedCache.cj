package aspire_extensions_caching

import std.
import std.collection.concurrent.*

class MemoryDistributedCache <: IDistributedCache {
    private let _memory = ConcurrentHashMap<String, DistributedCacheEntry>()

    public func get(key: String): ?Array<Byte> {
        _memory.entryView(key){ entryView =>
            entryView.value = None
        }
        if (let Some(value) <- _memory.get(key)) {
            return value
        }
        return None
    }

    public func set(key: String, value: Array<Byte>, expiration: Duration): Unit {
    }

    public func refresh(key: String): Unit {
    }

    public func remove(key: String): Unit {
    }
}

struct DistributedCacheEntry {
    let value: Array<Byte> = []
    let expire: 
}
