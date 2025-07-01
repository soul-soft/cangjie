package soulsoft_web_mvc

import soulsoft_web_http.*

public interface IActionResult {
    func invoke(context: HttpContext): Unit
}
