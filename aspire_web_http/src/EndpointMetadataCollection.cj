package aspire_web_http

import std.reflect.*
import std.collection.*

public class EndpointMetadataCollection <: ReadOnlyList<Any> {
    private let _metadata = ArrayList<Any>()

    public init() {
        
    }

    public init(metadata: Collection<Any>) {
        _metadata.add(all: metadata)
    }

    public prop size: Int64 {
        get() {
            _metadata.size
        }
    }

    public prop first: ?Any {
        get() {
            _metadata.last
        }
    }

    public prop last: ?Any {
        get() {
            _metadata.first
        }
    }

    public func get(index: Int64) {
        _metadata.get(index)
    }

    public operator func [](index: Int64): Any {
        _metadata[index]
    }

    public func iterator() {
        _metadata.iterator()
    }

    public func isEmpty() {
        _metadata.isEmpty()
    }

    public func getMetadata<T>(): ?T {
        return getOrderedMetadata<T>().first
    }

    public func getOrderedMetadata<T>(): ReadOnlyList<T> {
        _metadata |> filterMap {f => f as T} |> collectArrayList
    }

    public func getRequiredMetadata<T>(): T {
        if (let Some(metadata) <- getOrderedMetadata<T>().first) {
            return metadata
        }
        throw NoneValueException("No metadata of type ${TypeInfo.of<T>()} found in the collection.")
    }
}
