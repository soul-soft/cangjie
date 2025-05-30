package soulsoft_asp_mvc

import std.reflect.*
import soulsoft_asp_mvc.controllers.*

private let BASE_CONTROLLER_TYPE_INFO = TypeInfo.of<Controller>()

class DefaultControllerFeatureProvider <: ControllerFeatureProvider {
    public func isController(typeInfo: TypeInfo): Bool {
        if (let classTypeInfo: ClassTypeInfo <- typeInfo) {
            if (classTypeInfo.isAbstract()) {
                return false
            }
            if (!classTypeInfo.isSubtypeOf(BASE_CONTROLLER_TYPE_INFO)) {
                return false
            }          
            return true
        } else {
            return false
        }
    }
}
