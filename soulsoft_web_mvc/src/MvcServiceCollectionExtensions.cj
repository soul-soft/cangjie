package soulsoft_web_mvc

import std.reflect.*
import std.collection.*
import soulsoft_web_routing.*
import soulsoft_web_mvc.routing.*
import soulsoft_web_mvc.bindings.*
import soulsoft_extensions_options.*
import soulsoft_web_mvc.controllers.*
import soulsoft_web_mvc.application.*
import soulsoft_extensions_injection.*
import soulsoft_web_mvc.abstractions.*

public interface MvcServiceCollectionExtensions {
    func addControllers(): MvcBuilder
}

extend ServiceCollection <: MvcServiceCollectionExtensions {

    public func addControllers(): MvcBuilder {
        let builder = this.addMvcCore()
        return builder
    }

    private func addMvcCore() {
        let partManager = getApplicationPartManager()
        tryAddSingleton<ApplicationPartManager>(partManager)
        configureDefaultFeatureProviders(partManager)
        configureDefaultServices()
        addMvcCoreServices()
        return MvcBuilder(this, partManager)
    }

    private func getApplicationPartManager() {
        let service = this.iterator().filter {f => f.serviceType == TypeInfo.of<ApplicationPartManager>()}.first()
        if (let Some(serviceDescriptor) <- service) {
            if (let Some(instance) <- serviceDescriptor.implementationInstance.flatMap{f => f as ApplicationPartManager}) {
                return instance
            }
        }
        return ApplicationPartManager()
    }

    private func configureDefaultFeatureProviders(partManager: ApplicationPartManager) {
        if (!(partManager.featureProviders |> any{a => a is ControllerFeatureProvider})) {
            partManager.featureProviders.add(DefaultControllerFeatureProvider())
        }
    }

    private func configureDefaultServices() {
        addRouting()
    }

    private func addMvcCoreServices() {
        //controller
        this.tryAddSingleton<IControllerFactory, ControllerFactory>()
        this.tryAddSingleton<ActionEndpointFactory, ActionEndpointFactory>()
        this.tryAddSingleton<IActionDescriptorFactory, ActionDescriptorFactory>()
        //binding
        this.tryAddSingleton<IModelBinder, DefaultModelBinder>()
    }
}
