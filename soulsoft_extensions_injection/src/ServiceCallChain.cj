package soulsoft_extensions_injection

import std.collection.*
import std.sync.ReentrantMutex

/*
服务访问链路：进行循环依赖检测
 */
class ServiceCallChain {
    //依赖路径
    private let _items: HashSet<ServiceIdentifier> = HashSet<ServiceIdentifier>()

    public func checkLoopDependency(identifier: ServiceIdentifier) {
        if (_items.contains(identifier)) {
            let path = buildLoopDependencyPath(identifier)
            throw Exception("A circular dependency has been detected, with the following path: ${path}.")
        }
    }

    public func add(identifier: ServiceIdentifier) {
        _items.add(identifier)
    }

    private func buildLoopDependencyPath(identifier: ServiceIdentifier) {
        let sb = StringBuilder()
        let list = _items |> collectArrayList
        list.add(identifier)
        for ((index, pattern) in list |> enumerate) {
            sb.append(pattern)
            if (index + 1 < list.size) {
                sb.append(" -> ")
            }
        }
        return sb.toString()
    }
}
