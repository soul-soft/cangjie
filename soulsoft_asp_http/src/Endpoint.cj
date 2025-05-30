package soulsoft_asp_http

import std.collection.*

public abstract class Endpoint {
    private let _displayName: ?String
    private let _delegate: RequestDelegate
    private let _metadata: EndpointMetadataCollection

    public init(delegate: RequestDelegate, metadata: EndpointMetadataCollection, displayName: ?String) {
        _delegate = delegate
        _metadata = metadata
        _displayName = displayName
    }

    public prop delegate: RequestDelegate {
        get() {
            _delegate
        }
    }

    public prop metadata: EndpointMetadataCollection {
        get() {
            _metadata
        }
    }

    public prop displayName: ?String {
        get() {
            _displayName
        }
    }
}
