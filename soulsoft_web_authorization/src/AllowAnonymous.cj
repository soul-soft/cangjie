package soulsoft_web_authorization

import soulsoft_web_http.*

@Annotation[target: [Type, MemberFunction]]
public class AllowAnonymous <: IAllowAnonymous{
    public const init() {
    }
}