package soulsoft_extensions_injection

import std.reflect.*

public interface IServiceProvider {
    func createScope(): IServiceScope
    func getAll<T>(): Array<T>
    func getOrDefault(typeInfo: TypeInfo): ?Object
    func getOrDefault<T>(): ?T {
        if (let Some(instance) <- getOrDefault(TypeInfo.of<T>()).flatMap{ f => f as T}) {
            return instance
        }
        return None
    }

    func getOrThrow(typeInfo: TypeInfo): Object {
        getOrDefault(typeInfo).getOrThrow()
    }

    func getOrThrow<T>(): T {
        getOrDefault<T>().getOrThrow()
    }
}
