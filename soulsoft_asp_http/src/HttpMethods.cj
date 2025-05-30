package soulsoft_asp_http

public struct HttpMethods {
    public static const get = "get"
    public static const put = "put"
    public static const post = "post"
    public static const head = "head"
    public static const patch = "patch"
    public static const trace = "trace"
    public static const delete = "delete"
    public static const connect = "connect"
    public static const options = "options"

    public static func isGet(method: String) {
        return get == method
    }
    public static func isPut(method: String) {
        return put == method
    }
    public static func isPost(method: String) {
        return post == method
    }
    public static func isHead(method: String) {
        return head == method
    }
    public static func isPatch(method: String) {
        return patch == method
    }
    public static func isTrace(method: String) {
        return trace == method
    }
    public static func isDelete(method: String) {
        return delete == method
    }
    public static func isConnect(method: String) {
        return connect == method
    }
    public static func isOptions(method: String) {
        return options == method
    }
}
