package aspire_extensions_caching

import std.time.*
import std.collection.*
import std.collection.concurrent.*

class MemoryDistributedCache <: IDistributedCache {
    private let _memory = ConcurrentHashMap<String, MemoryDistributedCacheEntry>()

    public func get(key: String): ?Array<Byte> {
        return _memory.entryView(key) {
                entryView => if (let Some(value) <- entryView.value) {
                    if (value.isExpire()) {
                        entryView.value = None
                    }
                }
            }
            .flatMap {f => f.data}
    }

    public func set(key: String, value: Array<Byte>, options: DistributedCacheEntryOptions): Unit {
         _memory.entryView(key) { entryView => 
            entryView.value = MemoryDistributedCacheEntry(value, DateTime.now(), options)
        }
    }

    public func refresh(key: String): Unit {
        _memory.entryView(key) {
            entryView => if (let Some(value) <- entryView.value) {
                if (value.isExpire()) {
                    entryView.value = None
                }
            }
        }
    }

    public func remove(key: String): Unit {
        _memory.remove(key)
    }
}

class MemoryDistributedCacheEntry {
    MemoryDistributedCacheEntry(let data: Array<Byte>,let creationTime: DateTime, let options: DistributedCacheEntryOptions) {

    }

    func isExpire() {
        options.absoluteExpirationRelativeToNow.flatMap{span => DateTime.now() - creationTime > span} == true || 
        options.absoluteExpiration.flatMap{time => DateTime.now() > time} == true
    }
}
