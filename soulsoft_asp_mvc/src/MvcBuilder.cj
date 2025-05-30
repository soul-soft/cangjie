package soulsoft_asp_mvc

import std.reflect.*
import soulsoft_extensions_options.*
import soulsoft_asp_mvc.application.*
import soulsoft_extensions_injection.*

public class MvcBuilder {
    private let _services: ServiceCollection
    private let _partManager: ApplicationPartManager

    init(services: ServiceCollection, partManager: ApplicationPartManager) {
        _services = services
        _partManager = partManager
    }

    public prop services: ServiceCollection {
        get() {
            _services
        }
    }

    public prop partManager: ApplicationPartManager {
        get() {
            _partManager
        }
    }

    public func addMvcOptions(configureOptions: (MvcOptions) -> Unit) {
        _services.configure(configureOptions)
    }
}

/*
Extensions ApplicationPartManager
 */
extend MvcBuilder {
    public func addApplicationPart(module: ModuleInfo) {
        partManager.parts.add(ModulePart(module))
    }

    public func addApplicationPart(name: String, types: Array<TypeInfo>) {
        partManager.parts.add(AssemblyPart(name, types))
    }

    public func configureApplicationPartManager(configureOptions: (ApplicationPartManager) -> Unit) {
        configureOptions(partManager)
    }
}
