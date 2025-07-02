package soulsoft_web_staticfiles

import std.convert.*
import std.collection.*

class StaticFileContent {

    StaticFileContent(let fileInfo: IFileInfo, let contentType: String) {
    }

    public func serve(context: HttpContext) {
        let etagValue = calcEtagValue(fileInfo)
        if(isNotModified(context, etagValue)) {
            context.response.status(HttpStatusCode.NotModified)
        }else {
            context.response.addHeader("ETag", etagValue)
            context.response.addHeader("Content-Type", contentType)
            context.response.write(fileInfo.createReadStream())
        }
    }

    private func isNotModified(context: HttpContext, etagValue: String) {
        let ifNoneMatchValues = context.request.headers.get("If-None-Match")
        if ((ifNoneMatchValues |> any{f => f == "*"}) || (ifNoneMatchValues |> any{f => f == etagValue})) {
            return true
        }
        return false
    }

    private func calcEtagValue(fileInfo: IFileInfo) {
        let etagHash = fileInfo.lastModified.inUTC().toUnixTimeStamp().toMicroseconds() ^ fileInfo.size
        return etagHash.format('x')
    }
}
