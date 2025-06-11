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
}
