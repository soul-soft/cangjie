package soulsoft_web_mvc.annotations

import soulsoft_web_mvc.abstractions.*

@Annotation[target: [Type]]
public class Route <: IRouteTemplateProvider {
    private let _template: String

    public const init(template: String) {
        this._template = template
    }

    public prop template: ?String {
        get() {
            _template
        }
    }
}
