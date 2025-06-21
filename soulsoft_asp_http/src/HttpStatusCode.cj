package soulsoft_asp_http

public struct HttpStatusCode {
    public static const Continue: UInt16 =                        100
    public static const SwitchingProtocols: UInt16 =             101
    public static const Processing: UInt16 =                      102
    public static const EarlyHints: UInt16 =                      103
    
    public static const Ok: UInt16 =                              200
    public static const Created: UInt16 =                         201
    public static const Accepted: UInt16 =                        202
    public static const NonAuthoritativeInfo: UInt16 =           203
    public static const NoContent: UInt16 =                       204
    public static const ResetContent: UInt16 =                    205
    public static const PartialContent: UInt16 =                  206
    public static const MultiStatus: UInt16 =                     207
    public static const AlreadyReported: UInt16 =                 208
    public static const ImUsed: UInt16 =                          226
    
    public static const MultipleChoices: UInt16 =                 300
    public static const MovedPermanently: UInt16 =                301
    public static const Found: UInt16 =                            302
    public static const SeeOther: UInt16 =                         303
    public static const NotModified: UInt16 =                      304
    public static const UseProxy: UInt16 =                         305
    public static const TemporaryRedirect: UInt16 =               307
    public static const PermanentRedirect: UInt16 =               308
    
    public static const BadRequest: UInt16 =                       400
    public static const Unauthorized: UInt16 =                     401
    public static const PaymentRequired: UInt16 =                  402
    public static const Forbidden: UInt16 =                        403
    public static const NotFound: UInt16 =                          404
    public static const MethodNotAllowed: UInt16 =                 405
    public static const NotAcceptable: UInt16 =                    406
    public static const ProxyAuthRequired: UInt16 =                407
    public static const RequestTimeout: UInt16 =                   408
    public static const Conflict: UInt16 =                          409
    public static const Gone: UInt16 =                              410
    public static const LengthRequired: UInt16 =                   411
    public static const PreconditionFailed: UInt16 =               412
    public static const RequestContentTooLarge: UInt16 =           413
    public static const RequestUriTooLong: UInt16 =                 414
    public static const UnsupportedMediaType: UInt16 =             415
    public static const RequestedRangeNotSatisfiable: UInt16 =      416
    public static const ExpectationFailed: UInt16 =                417
    public static const Teapot: UInt16 =                            418
    public static const MisdirectedRequest: UInt16 =               421
    public static const UnprocessableEntity: UInt16 =              422
    public static const Locked: UInt16 =                            423
    public static const FailedDependency: UInt16 =                 424
    public static const TooEarly: UInt16 =                          425
    public static const UpgradeRequired: UInt16 =                  426
    public static const PreconditionRequired: UInt16 =             428
    public static const TooManyRequests: UInt16 =                   429
    public static const RequestHeaderFieldsTooLarge: UInt16 =      431
    public static const UnavailableForLegalReasons: UInt16 =       451
    
    public static const InternalServerError: UInt16 =              500
    public static const NotImplemented: UInt16 =                    501
    public static const BadGateway: UInt16 =                        502
    public static const ServiceUnavailable: UInt16 =                503
    public static const GatewayTimeout: UInt16 =                    504
    public static const HttpVersionNotSupported: UInt16 =           505
    public static const VariantAlsoNegotiates: UInt16 =             506
    public static const InsufficientStorage: UInt16 =               507
    public static const LoopDetected: UInt16 =                      508
    public static const NotExtended: UInt16 =                       510
    public static const NetworkAuthenticationRequired: UInt16 =     511
}