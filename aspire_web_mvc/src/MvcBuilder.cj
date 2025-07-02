package aspire_web_mvc

import std.reflect.*
import aspire_extensions_options.*
import aspire_web_mvc.application.*
import aspire_extensions_injection.*

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

    public func addApplicationPart(name: String, types: Array<TypeInfo>) {
        partManager.parts.add(AssemblyPart(name, types))
    }

    public func configureApplicationPartManager(configureOptions: (ApplicationPartManager) -> Unit) {
        configureOptions(partManager)
    }
}
