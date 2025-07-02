package aspire_web_mvc

import aspire_web_http.*

public interface IActionResult {
    func invoke(context: HttpContext): Unit
}
