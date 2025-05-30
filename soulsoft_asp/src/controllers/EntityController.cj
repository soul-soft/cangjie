package soulsoft_asp.controllers

import soulsoft_asp_mvc.*
import stdx.encoding.json.*
import soulsoft_asp.models.*
import soulsoft_asp_hosting.*
import soulsoft_asp.services.*
import soulsoft_asp_authorization.*
import soulsoft_extensions_logging.*

@Route["api/[controller]"]
public class EntityController <: Controller {
    public EntityController(let _service: EntityService, let _env: IWebHostEnvironment) {
    }

    /*
    允许匿名方案
    */
    @HttpGet
    @AllowAnonymous
    public func get(@FromServices logFactory: ILoggerFactory, @FromQuery model: CreatingModel) {
        let logger = logFactory.createLogger<EntityController>()
        logger.info("home:get")
        _service.working()
        return json(model)
    }

    @HttpGet["{id}"]
    public func get(@FromServices logFactory: ILoggerFactory, @FromRoute id: Int64) {
        for ((key, value) in request.routeValues) {
            println("${key} = ${value}")
        }
        let logger = logFactory.createLogger<EntityController>()
        logger.info("entity:get/{id}")
        return content(id.toString())
    }

    @HttpDelete["{id}"]
    public func delete(@FromServices logFactory: ILoggerFactory, @FromRoute id: Int64) {
        let logger = logFactory.createLogger<EntityController>()
        logger.info("entity:delete/{id}")
        return content(id.toString())
    }

    @HttpPost
    public func post(@FromServices logFactory: ILoggerFactory, model: CreatingModel) {
        let logger = logFactory.createLogger<EntityController>()
        logger.info("entity:post")
        return json(model)
    }

    @HttpPut
    public func put(@FromServices logFactory: ILoggerFactory, @FromForm model: CreatingModel) {
        let logger = logFactory.createLogger<EntityController>()
        logger.info("entity:put")
        return json(model)
    }
}
