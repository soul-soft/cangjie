package soulsoft_web_mvc.controllers

import soulsoft_web_http.*

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