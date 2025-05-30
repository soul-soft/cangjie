package soulsoft_extensions_injection

import std.reflect.*
import std.collection.*

/*
用于将依赖链路闭环
    1. 该类负责完成整个依赖链路的创建（一次解析只创建一次）
 */
public class ServiceProviderEngine <: IServiceProvider {
    private let _provider: ServiceProvider
    private let _chain = ServiceCallChain()

    init(provider: ServiceProvider) {
        _provider = provider
    }

    public func createScope(): IServiceScope {
        _provider.createScope()
    }

    public func getOrDefault(serviceType: TypeInfo): ?Object {
        if (let Some(descriptor) <- _provider.services.findLast(serviceType)) {
            let identifier = ServiceIdentifier.fromDescriptor(descriptor)
            _chain.checkLoopDependency(identifier)
            _chain.add(identifier)
            return _provider.resolve(descriptor, this)
        }
        return None
    }

    public func getAll<T>(): Array<T> {
        let serviceType = TypeInfo.of<T>()
        let descriptors = _provider.services.findAll(serviceType)
        let list = ArrayList<T>()
        var slot = 0
        while (slot < descriptors.size) {
            //反转使得最后注册的slot为0，因为getOrDefault默认就是获取最后一个，并设置slot为0
            if (let instance: T <- _provider.resolve(descriptors[slot], this, slot: descriptors.size - slot - 1)) {
                list.add(instance)
            }
            slot++
        }
        return list |> collectArray
    }
}
