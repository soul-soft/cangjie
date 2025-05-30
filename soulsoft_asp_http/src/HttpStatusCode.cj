package soulsoft_asp_http

public struct HttpStatusCode {
    public static const STATUS_CONTINUE: UInt16 =                        100
    public static const STATUS_SWITCHING_PROTOCOLS: UInt16 =             101
    public static const STATUS_PROCESSING: UInt16 =                      102
    public static const STATUS_EARLY_HINTS: UInt16 =                     103
	
    public static const STATUS_OK: UInt16 =                              200
    public static const STATUS_CREATED: UInt16 =                         201
    public static const STATUS_ACCEPTED: UInt16 =                        202
    public static const STATUS_NON_AUTHORITATIVE_INFO: UInt16 =          203
    public static const STATUS_NO_CONTENT: UInt16 =                      204
    public static const STATUS_RESET_CONTENT: UInt16 =                   205
    public static const STATUS_PARTIAL_CONTENT: UInt16 =                 206
    public static const STATUS_MULTI_STATUS: UInt16 =                    207
    public static const STATUS_ALREADY_REPORTED: UInt16 =                208
    public static const STATUS_IM_USED: UInt16 =                         226
	
    public static const STATUS_MULTIPLE_CHOICES: UInt16 =                300
    public static const STATUS_MOVED_PERMANENTLY: UInt16 =               301
    public static const STATUS_FOUND: UInt16 =                           302
    public static const STATUS_SEE_OTHER: UInt16 =                       303
    public static const STATUS_NOT_MODIFIED: UInt16 =                    304
    public static const STATUS_USE_PROXY: UInt16 =                       305
    public static const STATUS_TEMPORARY_REDIRECT: UInt16 =              307
    public static const STATUS_PERMANENT_REDIRECT: UInt16 =              308
	
    public static const STATUS_BAD_REQUEST: UInt16 =                     400
    public static const STATUS_UNAUTHORIZED: UInt16 =                    401
    public static const STATUS_PAYMENT_REQUIRED: UInt16 =                402
    public static const STATUS_FORBIDDEN: UInt16 =                       403
    public static const STATUS_NOT_FOUND: UInt16 =                       404
    public static const STATUS_METHOD_NOT_ALLOWED: UInt16 =              405
    public static const STATUS_NOT_ACCEPTABLE: UInt16 =                  406
    public static const STATUS_PROXY_AUTH_REQUIRED: UInt16 =             407
    public static const STATUS_REQUEST_TIMEOUT: UInt16 =                 408
    public static const STATUS_CONFLICT: UInt16 =                        409
    public static const STATUS_GONE: UInt16 =                            410
    public static const STATUS_LENGTH_REQUIRED: UInt16 =                 411
    public static const STATUS_PRECONDITION_FAILED: UInt16 =             412
    public static const STATUS_REQUEST_CONTENT_TOO_LARGE: UInt16 =       413
    public static const STATUS_REQUEST_URI_TOO_LONG: UInt16 =            414
    public static const STATUS_UNSUPPORTED_MEDIA_TYPE: UInt16 =          415
    public static const STATUS_REQUESTED_RANGE_NOT_SATISFIABLE: UInt16 = 416
    public static const STATUS_EXPECTATION_FAILED: UInt16 =              417
    public static const STATUS_TEAPOT: UInt16 =                          418
    public static const STATUS_MISDIRECTED_REQUEST: UInt16 =             421
    public static const STATUS_UNPROCESSABLE_ENTITY: UInt16 =            422
    public static const STATUS_LOCKED: UInt16 =                          423
    public static const STATUS_FAILED_DEPENDENCY: UInt16 =               424
    public static const STATUS_TOO_EARLY: UInt16 =                       425
    public static const STATUS_UPGRADE_REQUIRED: UInt16 =                426
    public static const STATUS_PRECONDITION_REQUIRED: UInt16 =           428
    public static const STATUS_TOO_MANY_REQUESTS: UInt16 =               429
    public static const STATUS_REQUEST_HEADER_FIELDS_TOO_LARGE: UInt16 = 431
    public static const STATUS_UNAVAILABLE_FOR_LEGAL_REASONS: UInt16 =   451
	
    public static const STATUS_INTERNAL_SERVER_ERROR: UInt16 =           500
    public static const STATUS_NOT_IMPLEMENTED: UInt16 =                 501
    public static const STATUS_BAD_GATEWAY: UInt16 =                     502
    public static const STATUS_SERVICE_UNAVAILABLE: UInt16 =             503
    public static const STATUS_GATEWAY_TIMEOUT: UInt16 =                 504
    public static const STATUS_HTTP_VERSION_NOT_SUPPORTED: UInt16 =      505
    public static const STATUS_VARIANT_ALSO_NEGOTIATES: UInt16 =         506
    public static const STATUS_INSUFFICIENT_STORAGE: UInt16 =            507
    public static const STATUS_LOOP_DETECTED: UInt16 =                   508
    public static const STATUS_NOT_EXTENDED: UInt16 =                    510
    public static const STATUS_NETWORK_AUTHENTICATION_REQUIRED: UInt16 = 511
}