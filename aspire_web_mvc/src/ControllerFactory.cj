package aspire_web_mvc

import std.reflect.*
import aspire_web_mvc.controllers.*
import aspire_extensions_injection.*

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
