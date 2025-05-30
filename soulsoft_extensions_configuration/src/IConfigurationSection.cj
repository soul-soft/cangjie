package soulsoft_extensions_configuration

import std.collection.{collectArray, HashMap}

public interface IConfigurationSection <: IConfiguration {
    prop key: String
    prop value: ?String
    prop path: String
}
