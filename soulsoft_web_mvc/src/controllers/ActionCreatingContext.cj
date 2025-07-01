package soulsoft_web_mvc.controllers

import std.reflect.*

public class ActionContext {
    public let controllerType: TypeInfo
    public let actionFunction: InstanceFunctionInfo

    public init(controllerType: TypeInfo, actionFunction: InstanceFunctionInfo) {
        this.controllerType = controllerType
        this.actionFunction = actionFunction
    }

}