package soulsoft_asp_authentication

import soulsoft_asp_http.*

@Annotation[target: [Type, MemberFunction]]
public class AllowAnonymous <: IAllowAnonymous{
    public const init() {
    }
}