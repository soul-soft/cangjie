package soulsoft_web_mvc

import std.reflect.*
import soulsoft_web_mvc.controllers.*
import soulsoft_extensions_injection.*

class ControllerFactory <: IControllerFactory {
    public func create(context: ControllerContext): Object {
        let instance = ActivatorUtilities.createInstance(context.httpContext.services,
            context.actionDescriptor.controllerType)
        if (let controller: Controller <- instance) {
            controller.setup(context.httpContext)
        }
        return instance
    }
}
