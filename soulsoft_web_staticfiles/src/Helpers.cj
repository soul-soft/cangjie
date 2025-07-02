package soulsoft_web_staticfiles

class Helpers {
    public static func isGetOrHeadMethod(method: String) {
        return HttpMethods.isGet(method) || HttpMethods.isHead(method)
    }
}