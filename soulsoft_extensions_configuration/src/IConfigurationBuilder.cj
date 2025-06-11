package soulsoft_extensions_configuration

import std.io.{IOStream}
import std.collection.*

/*
配置构建接口
 */
public interface IConfigurationBuilder {
    prop sources: List<IConfigurationSource>
    prop properties: Map<String, Any>
    func add(source: IConfigurationSource): IConfigurationBuilder
    func build(): IConfigurationRoot
}
