package aspire_web_mvc.controllers

import std.reflect.*
import std.collection.*
import aspire_web_mvc.application.*

public abstract class ControllerFeatureProvider <: ApplicationFeatureProvider<ControllerFeature> {
    public func populate(parts: Collection<ApplicationPart>, feature: ControllerFeature): Unit {
        for (pattern in parts |> flatMap {f => f.types}) {
            if (isController(pattern) && !feature.controllers.contains(pattern)) {
                feature.controllers.add(pattern)
            }
        }
    }

    public func isController(typeInfo: TypeInfo): Bool
}
