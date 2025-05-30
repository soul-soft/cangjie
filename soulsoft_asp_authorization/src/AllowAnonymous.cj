package soulsoft_asp_authorization

import soulsoft_asp_http.*

@Annotation[target: [Type, MemberFunction]]
public class AllowAnonymous <: IAllowAnonymous{
    public const init() {
    }
}