package soulsoft_asp_mvc.controllers

public interface IActionDescriptorFactory {
    func create(context: ActionContext): ControllerActionDescriptor
}

public class ActionDescriptorFactory <: IActionDescriptorFactory {
    public func create(context: ActionContext): ControllerActionDescriptor {
        let actionName = context.actionFunction.name
        let controllerName = context.controllerType.name.removeSuffix("Controller").toAsciiLower()
        let descriptor = ControllerActionDescriptor(actionName, controllerName, context.controllerType, context.actionFunction)
        descriptor.endpointMetadata.add(all: context.controllerType.annotations)
        descriptor.endpointMetadata.add(all: context.actionFunction.annotations)
        return descriptor
    }
}
