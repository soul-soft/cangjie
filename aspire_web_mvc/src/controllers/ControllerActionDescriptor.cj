package aspire_web_mvc.controllers

import std.reflect.*
import std.collection.*
import aspire_web_mvc.abstractions.*

public class ControllerActionDescriptor {
    private let _actionName: String
    private let _controllerName: String
    private let _controllerType: TypeInfo
    private let _actionFunction: InstanceFunctionInfo
    private let _endpointMetadata = ArrayList<Object>()

    public init(actionName: String, controllerName: String, controllerType: TypeInfo, actionFunction: InstanceFunctionInfo) {
        _actionName = actionName
        _controllerName = controllerName
        _controllerType = controllerType
        _actionFunction = actionFunction
    }

    public prop actionName: String {
        get() {
            _actionName
        }
    }

    public prop controllerName: String {
        get() {
            _controllerName
        }
    }

    public prop controllerType: TypeInfo {
        get() {
            _controllerType
        }
    }

    public prop actionFunction: InstanceFunctionInfo {
        get() {
            _actionFunction
        }
    }

    public prop endpointMetadata: List<Object> {
        get() {
            _endpointMetadata
        }
    }
}
