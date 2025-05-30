package soulsoft_asp_mvc.controllers

import std.reflect.*

public interface IControllerFactory {
    func create(context: ControllerContext): Object
}
