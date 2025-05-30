package soulsoft_extensions_injection

import std.sync.*
import std.reflect.*
import std.collection.*

let SUPPER_SERVICE_PROVIDER_TYPE = TypeInfo.of<IServiceProvider>()

public class ServiceProvider <: IServiceProvider {
    private let _lock = Mutex()
    private let _root: ?ServiceProvider
    private let _services: ServiceCollection
    private let _options: ServiceProviderOptions
    private let _resources = ArrayList<Resource>()
    private let _instances = HashMap<SerivceCacheKey, Object>()

    init(services: ServiceCollection,options: ServiceProviderOptions,root!: ?ServiceProvider = None) {
        _root = root
        _options = options
        _services = services
    }

    public func createScope(): IServiceScope {
        return ServiceScope(ServiceProvider(_services, _options, root: this))
    }

    public func getOrDefault(serviceType: TypeInfo): ?Object {
        if(serviceType == SUPPER_SERVICE_PROVIDER_TYPE || serviceType.isSubtypeOf(SUPPER_SERVICE_PROVIDER_TYPE)){
            return getServiceProviderEngine() as Object
        }
        if (let Some(descriptor) <- _services.findLast(serviceType)) {   
            return resolve(descriptor, getServiceProviderEngine())
        }
        return None
    }

    public func getAll<T>(): Array<T> {
        let serviceType = TypeInfo.of<T>()
        let descriptors = _services.findAll(serviceType)
        let list = ArrayList<T>()
        var slot = 0
        while (slot < descriptors.size) {
            //反转使得最后注册的slot为0，因为getOrDefault默认就是获取最后一个，并设置slot为0
            if (let instance: T <- resolve(descriptors[slot], getServiceProviderEngine(),
                slot: descriptors.size - slot - 1)) {
                list.add(instance)
            }
            slot++
        }
        return list |> collectArray
    }

    private func getServiceProviderEngine(): IServiceProvider {
        if (_options.validateLoopDependency) {
            return  ServiceProviderEngine(this)
        }  
        return this
    }

    internal func resolve(descriptor: ServiceDescriptor, engine: IServiceProvider, slot!: Int64 = 0): Object {
        let identifier = ServiceIdentifier.fromDescriptor(descriptor)
        if (!descriptor.lifetime.isSingleton() && isRoot && _options.validateScopes) {
            throw Exception("Cannot resolve non-singleton service from the root container.")
        }
        if (descriptor.lifetime.isSingleton() && let Some(root) <- _root) {
            return root.resolve(descriptor, engine)
        }
        let cacheKey = SerivceCacheKey(identifier, slot)
        let instance = tryGetInstance(cacheKey, descriptor, engine)
        return instance
    }

    /*
    尝试从缓存获取
     */
    private func tryGetInstance(cacheKey: SerivceCacheKey, descriptor: ServiceDescriptor, engine: IServiceProvider) {
        //如果是瞬时的那么立即创建并返回
        if (descriptor.lifetime.isTransient()) {
            let instance = createInstance(descriptor, engine)
            tryAddResource(instance)
            return instance
        }
        //如果容器中存在缓存，那么立即返回
        if (_instances.contains(cacheKey)) {
            return _instances[cacheKey]
        }
        synchronized(_lock) {
            if (_instances.contains(cacheKey)) {
                return _instances[cacheKey]
            } else {
                let instance = createInstance(descriptor, engine)
                _instances.add(cacheKey, instance)
                tryAddResource(instance)
                return instance
            }
        }
    }
    /*
    直接创建
     */
    private func createInstance(descriptor: ServiceDescriptor, serviceProvider: IServiceProvider): Object {
        if (let Some(implementationFactory) <- descriptor.implementationFactory.flatMap {f => f as (IServiceProvider) -> Object}) {
            return implementationFactory(serviceProvider)
        } else if (let Some(instance) <- descriptor.implementationInstance) {
            return instance
        } else if (let Some(implementationType) <- descriptor.implementationType) {
            return ActivatorUtilities.createInstance(serviceProvider, implementationType)
        } else {
            throw UnsupportedException("Unable to create an instance for the service descriptor. The descriptor lacks a valid implementation factory, instance, or type. Please ensure that at least one of these is provided.")
        }
    }

    private func tryAddResource(instance: Object) {
        if (let resource: Resource <- instance) {
            _resources.add(resource)
        }
    }

    internal prop services: ServiceCollection {
        get() {
            _services
        }
    }

    internal prop resources: Array<Resource> {
        get() {
            _resources |> collectArray
        }
    }

    internal prop isRoot: Bool {
        get() {
            _root.isNone()
        }
    }

    ~init() {
        for (pattern in _resources) {
            if (pattern.isClosed()) {
                continue
            }
            try {
                pattern.close()
            } catch (_: Exception) {
            }
        }
    }
}
