package soulsoft_extensions_configuration

import std.collection.HashMap

/*
配置源
 */
public interface IConfigurationProvider {
    func load(): Unit
    func get(key: String): ?String
    func set(key: String, value: ?String): Unit
    func getChildKeys(earlierKeys: Iterable<String>, parentPath: ?String): Iterable<String>
}
