package aspire_web_mvc.controllers

import std.reflect.*

public interface IControllerFactory {
    func create(context: ControllerContext): Object
}
