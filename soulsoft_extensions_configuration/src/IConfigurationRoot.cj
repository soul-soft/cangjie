package soulsoft_extensions_configuration

import std.collection.*

public interface IConfigurationRoot <: IConfiguration {
    prop providers: List<IConfigurationProvider>
}
