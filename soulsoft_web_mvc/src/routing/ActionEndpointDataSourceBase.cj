package soulsoft_web_mvc.routing

import std.sync.*
import std.collection.*
import soulsoft_web_http.*
import soulsoft_web_routing.*
import soulsoft_web_mvc.application.*
import soulsoft_web_mvc.controllers.*
import soulsoft_extensions_injection.*

public abstract class ActionEndpointDataSourceBase <: EndpointDataSource {
    private let _lock = Mutex()
    private let _services: IServiceProvider
    private let _partManager: ApplicationPartManager
    private let _actionFactory: IActionDescriptorFactory
    private var _endpoints: ?ReadOnlyList<Endpoint> = None
    private let _conventions = ArrayList<(EndpointBuilder) -> Unit>()
    private let _defaultBuilder: ControllerActionEndpointConventionBuilder

    protected init(services: IServiceProvider) {
        _services = services
        _partManager = services.getOrThrow<ApplicationPartManager>()
        _actionFactory = services.getOrThrow<IActionDescriptorFactory>()
        _defaultBuilder = ControllerActionEndpointConventionBuilder(_lock, _conventions)
    }

    public prop endpoints: ReadOnlyList<Endpoint> {
        get() {
            initialize()
            _endpoints.getOrThrow()
        }
    }

    protected prop lock: Mutex {
        get() {
            _lock
        }
    }

    protected prop services: IServiceProvider {
        get() {
            _services
        }
    }

    protected prop defaultBuilder: ControllerActionEndpointConventionBuilder {
        get() {
            _defaultBuilder
        }
    }

    private func initialize() {
        if (let Some(endpoints) <- _endpoints) {
            return
        } else {
            if (let Some(endpoints) <- _endpoints) {
                return
            }
            synchronized(_lock) {
                let actionDescriptors = createActionDescriptors()
                _endpoints = createEndpoints(actionDescriptors, _conventions)
            }
        }
    }

    private func createActionDescriptors(): ReadOnlyList<ControllerActionDescriptor> {
        let feature = ControllerFeature()
        _partManager.populateFeature(feature)
        let results = ArrayList<ControllerActionDescriptor>()
        for (controllerType in feature.controllers) {
            for (actionFunction in controllerType.instanceFunctions) {
                results.add(_actionFactory.create(ActionContext(controllerType, actionFunction)))
            }
        }
        return results
    }

    protected func createEndpoints(
        actions: ReadOnlyList<ControllerActionDescriptor>,
        conventions: ArrayList<(EndpointBuilder) -> Unit>
    ): ReadOnlyList<Endpoint>
}
