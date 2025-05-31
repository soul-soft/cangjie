package soulsoft_extensions_injection

import std.reflect.*
import std.collection.*

/*
服务提供者构建器
 */
extend ServiceCollection {
    //Singleton
    public func addSingleton<TService>(instance: TService) {
        add(ServiceDescriptor.singleton<TService>(instance))
        return this
    }

    public func addSingleton<TService, TImplementation>(instance: TImplementation) where TImplementation <: Object {
        add(ServiceDescriptor.singleton<TService, TImplementation>(instance))
        return this
    }

    public func addSingleton<TService, TImplementation>() where TImplementation <: Object {
        add(ServiceDescriptor.singleton<TService, TImplementation>())
        return this
    }

    public func addSingleton<TService, TImplementation>(sp: (IServiceProvider) -> TImplementation) where TImplementation <: Object {
        add(ServiceDescriptor.singleton<TService, TImplementation>(sp))
        return this
    }

    public func addSingleton<TService>(sp: (IServiceProvider) -> TService) where TService <: Object {
        add(ServiceDescriptor.singleton<TService, TService>(sp))
        return this
    }

    public func addSingleton(serviceType: TypeInfo) {
        add(ServiceDescriptor.singleton(serviceType, serviceType))
        return this
    }

    public func addSingleton(serviceType: TypeInfo, implementationType: TypeInfo) {
        add(ServiceDescriptor.singleton(serviceType, implementationType))
        return this
    }

    //try Singleton
    public func tryAddSingleton<TService>(instance: TService) where TService <: Object {
        tryAdd(ServiceDescriptor.singleton<TService>(instance))
        return this
    }

    public func tryAddSingleton<TService, TImplementation>() where TImplementation <: Object {
        tryAdd(ServiceDescriptor.singleton<TService, TImplementation>())
        return this
    }

    public func tryAddSingleton<TService, TImplementation>(instance: TImplementation) where TImplementation <: Object {
        tryAdd(ServiceDescriptor.singleton<TService, TImplementation>(instance))
        return this
    }

    public func tryAddSingleton<TService, TImplementation>(sp: (IServiceProvider) -> TImplementation) where TImplementation <: Object {
        tryAdd(ServiceDescriptor.singleton<TService, TImplementation>(sp))
        return this
    }

    public func tryAddSingleton(serviceType: TypeInfo) {
        tryAdd(ServiceDescriptor.singleton(serviceType, serviceType))
        return this
    }

    public func tryAddSingleton(serviceType: TypeInfo, implementationType: TypeInfo) {
        tryAdd(ServiceDescriptor.singleton(serviceType, implementationType))
        return this
    }

    //Scoped
    public func addScoped<TService, TImplementation>() where TImplementation <: Object {
        add(ServiceDescriptor.scoped<TService, TImplementation>())
        return this
    }

    public func addScoped<TService, TImplementation>(sp: (IServiceProvider) -> TImplementation) where TImplementation <: Object {
        add(ServiceDescriptor.scoped<TService, TImplementation>(sp))
        return this
    }

    public func addScoped<TService>(sp: (IServiceProvider) -> TService) where TService <: Object {
        println(ClassTypeInfo.of<TService>())
        add(ServiceDescriptor.scoped<TService, TService>(sp))
        return this
    }

    public func addScoped(serviceType: TypeInfo) {
        add(ServiceDescriptor.scoped(serviceType, serviceType))
        return this
    }

    public func addScoped(serviceType: TypeInfo, implementationType: TypeInfo) {
        add(ServiceDescriptor.scoped(serviceType, implementationType))
        return this
    }

    //try Scoped
    public func tryAddScoped<TService, TImplementation>() where TImplementation <: Object {
        tryAdd(ServiceDescriptor.scoped<TService, TImplementation>())
        return this
    }

    public func tryAddScoped<TService, TImplementation>(sp: (IServiceProvider) -> TImplementation) where TImplementation <: Object {
        tryAdd(ServiceDescriptor.scoped<TService, TImplementation>(sp))
        return this
    }

    public func tryAddScoped(serviceType: TypeInfo) {
        tryAdd(ServiceDescriptor.scoped(serviceType, serviceType))
        return this
    }

    public func tryAddScoped(serviceType: TypeInfo, implementationType: TypeInfo) {
        tryAdd(ServiceDescriptor.scoped(serviceType, implementationType))
        return this
    }

    //Transient
    public func addTransient<TService, TImplementation>() {
        add(ServiceDescriptor.transient<TService, TImplementation>())
        return this
    }

    public func addTransient<TService, TImplementation>(sp: (IServiceProvider) -> TImplementation) where TImplementation <: Object {
        add(ServiceDescriptor.transient<TService, TImplementation>(sp))
        return this
    }

    public func addTransient<TService>(sp: (IServiceProvider) -> TService) where TService <: Object {
        add(ServiceDescriptor.transient<TService, TService>(sp))
        return this
    }

    public func addTransient(serviceType: TypeInfo) {
        add(ServiceDescriptor.transient(serviceType, serviceType))
        return this
    }

    public func addTransient(serviceType: TypeInfo, implementationType: TypeInfo) {
        add(ServiceDescriptor.transient(serviceType, implementationType))
        return this
    }

    //try Scoped
    public func tryAddTransient<TService, TImplementation>() where TImplementation <: Object {
        tryAdd(ServiceDescriptor.transient<TService, TImplementation>())
        return this
    }

    public func tryAddTransient<TService, TImplementation>(sp: (IServiceProvider) -> TImplementation) where TImplementation <: Object {
        tryAdd(ServiceDescriptor.transient<TService, TImplementation>(sp))
        return this
    }

    public func tryAddTransient(serviceType: TypeInfo) {
        tryAdd(ServiceDescriptor.transient(serviceType, serviceType))
        return this
    }

    public func tryAddTransient(serviceType: TypeInfo, implementationType: TypeInfo) {
        tryAdd(ServiceDescriptor.transient(serviceType, implementationType))
        return this
    }

    public func tryAddEnumerable(descriptor: ServiceDescriptor) {
        if (this |>
            any {f => f.serviceType == descriptor.serviceType && f.implementationType == descriptor.implementationType}) {
            return this
        }
        add(descriptor)
        return this
    }

    public func tryAddEnumerable(descriptors: Collection<ServiceDescriptor>) {
        for (pattern in descriptors) {
            tryAddEnumerable(pattern)
        }
        return this
    }

}
