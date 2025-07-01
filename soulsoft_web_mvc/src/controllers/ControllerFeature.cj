package soulsoft_web_mvc.controllers

import std.reflect.*
import std.collection.*

public class ControllerFeature {
    private let _controllers = HashSet<TypeInfo>()

    public prop controllers: Set<TypeInfo> {
        get() {
            _controllers
        }
    }
}
