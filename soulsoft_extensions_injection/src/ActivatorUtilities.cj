package soulsoft_extensions_injection

import std.reflect.*
import std.collection.*

public class ActivatorUtilities {
    public static func createInstance<T>(serviceProvider: IServiceProvider, args: Array<Any>): T {
        let obj = createInstance(serviceProvider, TypeInfo.of<T>(), args) as T
        return obj.getOrThrow()
    }

    public static func createInstance(serviceProvider: IServiceProvider, typeInfo: TypeInfo, args: Array<Any>): Object {
        if (let classTypeInfo: ClassTypeInfo <- typeInfo) {
            for (constructor in classTypeInfo.constructors) {
                if (let Some(instance) <- apply(constructor, serviceProvider, args)) {
                    return instance
                }
            }
        }
        throw UnsupportedException(
            "Failed to create an instance because no applicable constructor was found for the type '${typeInfo}'. Ensure that the provided arguments match one of the constructors' signatures."
        )
    }

    static func apply(constructor: ConstructorInfo, sp: IServiceProvider, customArguments: Array<Any>): ?Object {
        var customArgumentIndex = 0
        let arguments = ArrayList<Any>()
        for (pattern in constructor.parameters) {
            if (let Some(argument) <- sp.getOrDefault(pattern.typeInfo)) {
                arguments.add(argument)
            } else {
                if (customArguments.size <= customArgumentIndex) {
                    return None
                }
                let customArgument = customArguments[customArgumentIndex]
                let customArgumentType = TypeInfo.of(customArgument)
                if (!(customArgumentType == pattern.typeInfo || customArgumentType.isSubtypeOf(pattern.typeInfo))) {
                    return None
                }
                arguments.add(customArguments[customArgumentIndex])
                customArgumentIndex += 1
            }
        }
        return constructor.apply(arguments |> collectArray) as Object
    }
}
