package soulsoft_asp_mvc.application

import std.reflect.*
import std.collection.*

public class ModulePart <: ApplicationPart {
    private let _moduleInfo: ModuleInfo

    public init(moduleInfo: ModuleInfo) {
        _moduleInfo = moduleInfo
    }

    public prop name: String {
        get() {
            _moduleInfo.name
        }
    }

    public prop types: Collection<TypeInfo> {
        get() {
            _moduleInfo.packages |> flatMap {f => f.typeInfos} |> collectArrayList
        }
    }
}
