package soulsoft_extensions_configuration

import std.reflect.*
import std.convert.*
import std.collection.*

/*
配置核心接口
 */
public interface IConfiguration {
    operator func [](name: String): ?String
    operator func [](name: String, value!: ?String): Unit
    func getSection(name: String): IConfigurationSection
    func getChildren(): Collection<IConfigurationSection>       
    
    func getValue(typeInfo: TypeInfo, name: String): ?Any {
        if (let Some(value) <- this[name]) {
            if (TypeInfo.of<String>() == typeInfo) {
                return value
            }
            if (TypeInfo.of<Int64>() == typeInfo) {
                return Int64.parse(value)
            }
            if (TypeInfo.of<Rune>() == typeInfo) {
                return value.toRuneArray().first.flatMap {f => f as Any}
            }
            if (TypeInfo.of<Bool>() == typeInfo) {
                return Bool.parse(value)
            }
            return value
        }
        return None
    }

    func getValue<T>(name: String): ?T {
        let typeInfo = TypeInfo.of<T>()
        return getValue(typeInfo, name).flatMap {f => f as T}
    }

    func bind(name: String, instance: Object): Unit {
        let typeInfo = ClassTypeInfo.of(instance)
        let section = getSection(name)
        for (pattern in typeInfo.instanceVariables) {
            if (!pattern.isMutable()) {
                continue
            }
            if (let Some(value) <- section.getValue(pattern.typeInfo, pattern.name)) {
                pattern.setValue(instance, value)
            }
        }
    }
}
