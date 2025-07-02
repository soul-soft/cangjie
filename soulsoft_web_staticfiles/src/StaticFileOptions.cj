package soulsoft_web_staticfiles

public class StaticFileOptions <: SharedOptionsBase {
    public var serveUnknownFileTypes = false
    public var defaultContentType:? String = None
    public var contentTypeProvider: ?IContentTypeProvider = None
}
