package soulsoft_asp_mvc

import std.io.*
import std.reflect.*
import std.collection.*
import soulsoft_asp_http.*
import stdx.encoding.json.*
import stdx.serialization.*
import soulsoft_asp_mvc.bindings.*
import stdx.serialization.serialization.*

class DefaultModelBinder <: IModelBinder {
   
    public func bind(context: ModelBindingContext): Array<Any> {
        let models = ArrayList<Any>()
        for (pattern in context.parameters) {
            if (pattern.annotations |> any {f => f is FromBody}) {
                models.add(fromBody(pattern, context.httpContext))
            } else if (pattern.annotations |> any {f => f is FromQuery}) {
                models.add(fromQuery(pattern, context.httpContext))
            } else if (pattern.annotations |> any {f => f is FromForm}) {
                models.add(fromForm(pattern, context.httpContext))
            } else if (pattern.annotations |> any {f => f is FromRoute}) {
                models.add(fromRoute(pattern, context.httpContext))
            } else if (pattern.annotations |> any {f => f is FromServices}) {
                models.add(fromServices(pattern, context.httpContext))
            } else {
                models.add(fromBody(pattern, context.httpContext))
            }
        }
        return models |> collectArray
    }

    private func fromBody(parameter: ParameterInfo, context: HttpContext): Any {
        let jsonValue = JsonValue.fromStr(StringReader(context.request.body).readToEnd())
        let dm = DataModel.fromJson(jsonValue)
        return ModelBindingHelper.deserization(parameter.typeInfo, dm)
    }

    private func fromQuery(parameter: ParameterInfo, context: HttpContext): Any {
        return ModelBindingHelper.deserization(parameter, context.request.queryForm)
    }

    private func fromForm(parameter: ParameterInfo, context: HttpContext): Any {
        return ModelBindingHelper.deserization(parameter, context.request.form)
    }

    private func fromRoute(parameter: ParameterInfo, context: HttpContext): Any {
        return ModelBindingHelper.deserization(parameter, context.request.routeValues)
    }

    private func fromServices(parameter: ParameterInfo, context: HttpContext): Any {
        return context.services.getOrThrow(parameter.typeInfo)
    }
}
