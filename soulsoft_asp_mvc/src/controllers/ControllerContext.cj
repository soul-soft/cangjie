package soulsoft_asp_mvc.controllers

import soulsoft_asp_http.*

public class ControllerContext {
    private let _httpContext: HttpContext
    private let _actionDescriptor: ControllerActionDescriptor

    public init(httpContext: HttpContext, actionDescriptor: ControllerActionDescriptor) {
        _httpContext = httpContext
        _actionDescriptor = actionDescriptor
    }

    public prop httpContext: HttpContext{
        get(){
            _httpContext
        }
    }

    public prop actionDescriptor: ControllerActionDescriptor{
        get(){
            _actionDescriptor
        }
    }
}