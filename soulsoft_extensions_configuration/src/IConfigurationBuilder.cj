package soulsoft_extensions_configuration

import std.io.{IOStream}
import std.collection.*

/*
配置构建接口
 */
public interface IConfigurationBuilder {
    prop sources: List<IConfigurationSource>
    prop properties: HashMap<String, Any>
    func add(source: IConfigurationSource): IConfigurationBuilder
    func build(): IConfiguration
}
