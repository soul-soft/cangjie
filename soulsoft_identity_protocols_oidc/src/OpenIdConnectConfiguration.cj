package soulsoft_identity_protocols_oidc

import std.collection.*
import stdx.encoding.json.*
import soulsoft_identity_tokens_jwt.*
import stdx.serialization.serialization.*

/**
 * 表示 OpenID Connect 发现文档中的配置信息，用于客户端与身份提供者交互时的配置参考。
 */
public class OpenIdConnectConfiguration {

    /** 发行者标识，通常为 Identity Provider 的 URL */
    public var issuer = String.empty

    /** JSON Web Key Set (JWKS) 的 URI，用于获取签名和加密密钥 */
    public var jwksUri = String.empty

    /** 操作条款（Terms of Service）的 URI */
    public var opTosUri = String.empty

    /** 操作策略（Policy）的 URI */
    public var opPolicyUri = String.empty

    /** 获取访问令牌的端点 URL */
    public var tokenEndpoint = String.empty

    /** 获取用户信息的端点 URL */
    public var userInfoEndpoint = String.empty

    /** 结束会话的端点 URL */
    public var endSessionEndpoint = String.empty

    /** 令牌撤销的端点 URL */
    public var revocationEndpoint = String.empty

    /** 会话检查使用的 iframe URL */
    public var checkSessionIframe = String.empty

    /** 服务文档的 URI，一般指向更详细的服务说明 */
    public var serviceDocumentation = String.empty

    /** 客户端注册的端点 URL */
    public var registrationEndpoint = String.empty

    /** Token Introspection 端点 URL */
    public var introspectionEndpoint = String.empty

    /** 授权端点 URL，用于获取授权码、隐式授权等 */
    public var authorizationEndpoint = String.empty

    /** 是否支持 HTTP Logout */
    public var httpLogoutSupported = false

    /** 是否支持登出会话 */
    public var logoutSessionSupported = false

    /** 是否支持 claims 参数 */
    public var claimsParameterSupported = false

    /** 是否支持 request 参数 */
    public var requestParameterSupported = false

    /** 是否支持 request_uri 参数 */
    public var requestUriParameterSupported = false

    /** 是否必须注册 request_uri */
    public var requireRequestUriRegistration = false

    /** 是否支持前端通道登出会话，此处数据类型应为布尔或根据设计调整，当前为字符串 */
    public var frontchannelLogoutSessionSupported = String.empty

    /** 附加的未定义字段，保存额外的配置信息 */
    public var additionalData = HashMap<String, Any>()

    /** 支持的声明（claims）集合 */
    public var claimsSupported: Collection<String> = ArrayList<String>()

    /** 支持的作用域（scopes）集合 */
    public var scopesSupported: Collection<String> = ArrayList<String>()

    /** 支持的签名密钥集合 */
    public var signingKeys: Collection<SecurityKey> = ArrayList<SecurityKey>()

    /** 支持的 UI 语言列表 */
    public var uiLocalesSupported: Collection<String> = ArrayList<String>()

    /** 支持的响应模式集合 */
    public var responseModesSupported: Collection<String> = ArrayList<String>()

    /** 支持的响应类型集合 */
    public var responseTypesSupported: Collection<String> = ArrayList<String>()

    /** 支持的认证上下文类引用值集合 */
    public var acrValuesSupported: Collection<String> = ArrayList<String>()

    /** 支持的声明类型集合 */
    public var claimTypesSupported: Collection<String> = ArrayList<String>()

    /** 支持的授权类型集合 */
    public var grantTypesSupported: Collection<String> = ArrayList<String>()

    /** 支持的主题类型集合 */
    public var subjectTypesSupported: Collection<String> = ArrayList<String>()

    /** 支持的声明语言列表 */
    public var claimsLocalesSupported: Collection<String> = ArrayList<String>()

    /** 支持的显示值列表 */
    public var displayValuesSupported: Collection<String> = ArrayList<String>()

    /** 令牌端点支持的认证方法集合 */
    public var tokenEndpointAuthMethodsSupported: Collection<String> = ArrayList<String>()

    /** 令牌端点支持的签名算法集合 */
    public var tokenEndpointAuthSigningAlgValuesSupported: Collection<String> = ArrayList<String>()

    /** ID Token 加密算法支持列表 */
    public var idTokenEncryptionAlgValuesSupported: Collection<String> = ArrayList<String>()

    /** 请求对象签名算法支持列表 */
    public var requestObjectSigningAlgValuesSupported: Collection<String> = ArrayList<String>()

    /** 请求对象加密算法支持列表 */
    public var requestObjectEncryptionAlgValuesSupported: Collection<String> = ArrayList<String>()

    /** 请求对象加密加密方法支持列表 */
    public var requestObjectEncryptionEncValuesSupported: Collection<String> = ArrayList<String>()

    /** Introspection 端点支持的认证方法 */
    public var introspectionEndpointAuthMethodsSupported: Collection<String> = ArrayList<String>()

    /** UserInfo 端点支持的加密算法 */
    public var userInfoEndpointEncryptionAlgValuesSupported: Collection<String> = ArrayList<String>()

    /** UserInfo 端点支持的加密加密方法 */
    public var userInfoEndpointEncryptionEncValuesSupported: Collection<String> = ArrayList<String>()

    /** UserInfo 端点支持的签名算法 */
    public var userInfoEndpointSigningAlgValuesSupported: Collection<String> = ArrayList<String>()

    /** Introspection 端点支持的签名算法 */
    public var introspectionEndpointAuthSigningAlgValuesSupported: Collection<String> = ArrayList<String>()

    public func serialize(): DataModel {
        var dms = DataModelStruct()
        // Basic string fields
        dms.add(OpenIdProviderMetadataNames.Issuer, issuer, issuer.size > 0)
        dms.add(OpenIdProviderMetadataNames.JwksUri, jwksUri, jwksUri.size > 0)
        dms.add(OpenIdProviderMetadataNames.OpTosUri, opTosUri, opTosUri.size > 0)
        dms.add(OpenIdProviderMetadataNames.OpPolicyUri, opPolicyUri, opPolicyUri.size > 0)
        dms.add(OpenIdProviderMetadataNames.TokenEndpoint, tokenEndpoint, tokenEndpoint.size > 0)
        dms.add(OpenIdProviderMetadataNames.UserInfoEndpoint, userInfoEndpoint, userInfoEndpoint.size > 0)
        dms.add(OpenIdProviderMetadataNames.EndSessionEndpoint, endSessionEndpoint, endSessionEndpoint.size > 0)
        dms.add(OpenIdProviderMetadataNames.RevocationEndpoint, revocationEndpoint, revocationEndpoint.size > 0)
        dms.add(OpenIdProviderMetadataNames.CheckSessionIframe, checkSessionIframe, checkSessionIframe.size > 0)
        dms.add(OpenIdProviderMetadataNames.ServiceDocumentation, serviceDocumentation, serviceDocumentation.size > 0)
        dms.add(OpenIdProviderMetadataNames.RegistrationEndpoint, registrationEndpoint, registrationEndpoint.size > 0)
        dms.add(OpenIdProviderMetadataNames.IntrospectionEndpoint, introspectionEndpoint, introspectionEndpoint.size > 0)
        dms.add(OpenIdProviderMetadataNames.AuthorizationEndpoint, authorizationEndpoint, authorizationEndpoint.size > 0)
        dms.add(OpenIdProviderMetadataNames.FrontchannelLogoutSessionSupported, frontchannelLogoutSessionSupported, frontchannelLogoutSessionSupported.size > 0)

        // Boolean fields - always include since they have default values
        dms.add(OpenIdProviderMetadataNames.HttpLogoutSupported, httpLogoutSupported)
        dms.add(OpenIdProviderMetadataNames.LogoutSessionSupported, logoutSessionSupported)
        dms.add(OpenIdProviderMetadataNames.ClaimsParameterSupported, claimsParameterSupported)
        dms.add(OpenIdProviderMetadataNames.RequestParameterSupported, requestParameterSupported)
        dms.add(OpenIdProviderMetadataNames.RequestUriParameterSupported, requestUriParameterSupported)
        dms.add(OpenIdProviderMetadataNames.RequireRequestUriRegistration, requireRequestUriRegistration)

        // Collection fields - all using .size > 0
        dms.add(OpenIdProviderMetadataNames.ClaimsSupported, claimsSupported, claimsSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.ScopesSupported, scopesSupported, scopesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.UILocalesSupported, uiLocalesSupported, uiLocalesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.ResponseModesSupported, responseModesSupported, responseModesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.ResponseTypesSupported, responseTypesSupported, responseTypesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.AcrValuesSupported, acrValuesSupported, acrValuesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.ClaimTypesSupported, claimTypesSupported, claimTypesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.GrantTypesSupported, grantTypesSupported, grantTypesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.SubjectTypesSupported, subjectTypesSupported, subjectTypesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.ClaimsLocalesSupported, claimsLocalesSupported, claimsLocalesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.DisplayValuesSupported, displayValuesSupported, displayValuesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.TokenEndpointAuthMethodsSupported, tokenEndpointAuthMethodsSupported, tokenEndpointAuthMethodsSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.TokenEndpointAuthSigningAlgValuesSupported, tokenEndpointAuthSigningAlgValuesSupported, tokenEndpointAuthSigningAlgValuesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.IdTokenEncryptionAlgValuesSupported, idTokenEncryptionAlgValuesSupported, idTokenEncryptionAlgValuesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.RequestObjectSigningAlgValuesSupported, requestObjectSigningAlgValuesSupported, requestObjectSigningAlgValuesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.RequestObjectEncryptionAlgValuesSupported, requestObjectEncryptionAlgValuesSupported, requestObjectEncryptionAlgValuesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.RequestObjectEncryptionEncValuesSupported, requestObjectEncryptionEncValuesSupported, requestObjectEncryptionEncValuesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.IntrospectionEndpointAuthMethodsSupported, introspectionEndpointAuthMethodsSupported, introspectionEndpointAuthMethodsSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.UserInfoEncryptionAlgValuesSupported, userInfoEndpointEncryptionAlgValuesSupported, userInfoEndpointEncryptionAlgValuesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.UserInfoEncryptionEncValuesSupported, userInfoEndpointEncryptionEncValuesSupported, userInfoEndpointEncryptionEncValuesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.UserInfoSigningAlgValuesSupported, userInfoEndpointSigningAlgValuesSupported, userInfoEndpointSigningAlgValuesSupported.size > 0)
        dms.add(OpenIdProviderMetadataNames.IntrospectionEndpointAuthSigningAlgValuesSupported, introspectionEndpointAuthSigningAlgValuesSupported, introspectionEndpointAuthSigningAlgValuesSupported.size > 0)

        for ((name, value) in additionalData) {
            if (let data: String <- value) {
                dms.add(name, data, data.size > 0)
            } else if (let data: Bool <- value) {
                dms.add(name, data)
            } else if (let data: Int64 <- value) {
                dms.add(name, data)
            } else if(let data: Collection<String> <- value) {
                dms.add(name, data, data.size > 0)
            }else if(let data: Collection<String> <- value) {
                dms.add(name, data, data.size > 0)
            }else if(let data: ToJson <- value) {
                dms.add(Field(name, DataModel.fromJson(data.toJson())))
            }
        }

        return dms
    }

    public static func deserialize(dm: DataModel): OpenIdConnectConfiguration {
        var dms = match(dm){
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        var configuration = OpenIdConnectConfiguration()

        // 基础字符串类型
        configuration.issuer = String.deserialize(dms.get(OpenIdProviderMetadataNames.Issuer))
        configuration.jwksUri = String.deserialize(dms.get(OpenIdProviderMetadataNames.JwksUri))
        configuration.opTosUri = String.deserialize(dms.get(OpenIdProviderMetadataNames.OpTosUri))
        configuration.opPolicyUri = String.deserialize(dms.get(OpenIdProviderMetadataNames.OpPolicyUri))
        configuration.tokenEndpoint = String.deserialize(dms.get(OpenIdProviderMetadataNames.TokenEndpoint))
        configuration.userInfoEndpoint = String.deserialize(dms.get(OpenIdProviderMetadataNames.UserInfoEndpoint))
        configuration.endSessionEndpoint = String.deserialize(dms.get(OpenIdProviderMetadataNames.EndSessionEndpoint))
        configuration.revocationEndpoint = String.deserialize(dms.get(OpenIdProviderMetadataNames.RevocationEndpoint))
        configuration.checkSessionIframe = String.deserialize(dms.get(OpenIdProviderMetadataNames.CheckSessionIframe))
        configuration.serviceDocumentation = String.deserialize(dms.get(OpenIdProviderMetadataNames.ServiceDocumentation))
        configuration.registrationEndpoint = String.deserialize(dms.get(OpenIdProviderMetadataNames.RegistrationEndpoint))
        configuration.introspectionEndpoint = String.deserialize(dms.get(OpenIdProviderMetadataNames.IntrospectionEndpoint))
        configuration.authorizationEndpoint = String.deserialize(dms.get(OpenIdProviderMetadataNames.AuthorizationEndpoint))
        configuration.frontchannelLogoutSessionSupported = String.deserialize(dms.get(OpenIdProviderMetadataNames.FrontchannelLogoutSessionSupported))

        // 布尔类型
        configuration.httpLogoutSupported = Bool.deserialize(dms.get(OpenIdProviderMetadataNames.HttpLogoutSupported))
        configuration.logoutSessionSupported = Bool.deserialize(dms.get(OpenIdProviderMetadataNames.LogoutSessionSupported))
        configuration.claimsParameterSupported = Bool.deserialize(dms.get(OpenIdProviderMetadataNames.ClaimsParameterSupported))
        configuration.requestParameterSupported = Bool.deserialize(dms.get(OpenIdProviderMetadataNames.RequestParameterSupported))
        configuration.requestUriParameterSupported = Bool.deserialize(dms.get(OpenIdProviderMetadataNames.RequestUriParameterSupported))
        configuration.requireRequestUriRegistration = Bool.deserialize(dms.get(OpenIdProviderMetadataNames.RequireRequestUriRegistration))

        // claimsSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.ClaimsSupported)) {
            configuration.claimsSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // scopesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.ScopesSupported)) {
            configuration.scopesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // uiLocalesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.UILocalesSupported)) {
            configuration.uiLocalesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // responseModesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.ResponseModesSupported)) {
            configuration.responseModesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // responseTypesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.ResponseTypesSupported)) {
            configuration.responseTypesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // acrValuesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.AcrValuesSupported)) {
            configuration.acrValuesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // claimTypesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.ClaimTypesSupported)) {
            configuration.claimTypesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // grantTypesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.GrantTypesSupported)) {
            configuration.grantTypesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // subjectTypesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.SubjectTypesSupported)) {
            configuration.subjectTypesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // claimsLocalesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.ClaimsLocalesSupported)) {
            configuration.claimsLocalesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // displayValuesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.DisplayValuesSupported)) {
            configuration.displayValuesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // tokenEndpointAuthMethodsSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.TokenEndpointAuthMethodsSupported)) {
            configuration.tokenEndpointAuthMethodsSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // tokenEndpointAuthSigningAlgValuesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.TokenEndpointAuthSigningAlgValuesSupported)) {
            configuration.tokenEndpointAuthSigningAlgValuesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // idTokenEncryptionAlgValuesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.IdTokenEncryptionAlgValuesSupported)) {
            configuration.idTokenEncryptionAlgValuesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // requestObjectSigningAlgValuesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.RequestObjectSigningAlgValuesSupported)) {
            configuration.requestObjectSigningAlgValuesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // requestObjectEncryptionAlgValuesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.RequestObjectEncryptionAlgValuesSupported)) {
            configuration.requestObjectEncryptionAlgValuesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // requestObjectEncryptionEncValuesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.RequestObjectEncryptionEncValuesSupported)) {
            configuration.requestObjectEncryptionEncValuesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // introspectionEndpointAuthMethodsSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.IntrospectionEndpointAuthMethodsSupported)) {
            configuration.introspectionEndpointAuthMethodsSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // userInfoEndpointEncryptionAlgValuesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.UserInfoEncryptionAlgValuesSupported)) {
            configuration.userInfoEndpointEncryptionAlgValuesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // userInfoEndpointEncryptionEncValuesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.UserInfoEncryptionEncValuesSupported)) {
            configuration.userInfoEndpointEncryptionEncValuesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // userInfoEndpointSigningAlgValuesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.UserInfoSigningAlgValuesSupported)) {
            configuration.userInfoEndpointSigningAlgValuesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        // introspectionEndpointAuthSigningAlgValuesSupported
        if (let seq: DataModelSeq <- dms.get(OpenIdProviderMetadataNames.IntrospectionEndpointAuthSigningAlgValuesSupported)) {
            configuration.introspectionEndpointAuthSigningAlgValuesSupported = seq.getItems() |> map { f => String.deserialize(f) } |> collectArrayList
        }

        return configuration
    }

    public static func create(json: String) {
        return deserialize(DataModel.fromJson(JsonValue.fromStr(json)))
    }

    public static func wirte(configuration: OpenIdConnectConfiguration) {
        return configuration.serialize().toJson().toJsonString()
    }
}