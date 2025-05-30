package soulsoft_extensions_injection

import std.reflect.*

/*
服务唯一性标识
 */
struct ServiceIdentifier <: Hashable & Equatable<ServiceIdentifier> & ToString {
    private let _serviceType: TypeInfo

    public init(serviceType: TypeInfo) {
        _serviceType = serviceType
    }

    public prop serviceType: TypeInfo {
        get() {
            _serviceType
        }
    }

    public static func fromServiceType(serviceType: TypeInfo) {
        ServiceIdentifier(serviceType)
    }

    public static func fromDescriptor(descriptor: ServiceDescriptor) {
        ServiceIdentifier(descriptor.serviceType)
    }

    public operator func ==(oth: ServiceIdentifier) {
        return this._serviceType == oth._serviceType
    }

    public func hashCode() {
        return _serviceType.hashCode()
    }

    public func toString() {
        "${_serviceType}"
    }
}
