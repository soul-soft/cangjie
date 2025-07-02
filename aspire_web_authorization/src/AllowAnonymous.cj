package aspire_web_authorization

import aspire_web_http.*

@Annotation[target: [Type, MemberFunction]]
public class AllowAnonymous <: IAllowAnonymous{
    public const init() {
    }
}