package soulsoft_asp_mvc

import soulsoft_asp_http.*

public interface IActionResult {
    func invoke(context: HttpContext): Unit
}
