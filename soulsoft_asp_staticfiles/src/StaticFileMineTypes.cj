package soulsoft_asp_staticfiles

import std.collection.*

class StaticFileMineTypes {
   private static let MIME_TYPES = HashMap<String, String>(
        (".html", "text/html"),
        (".htm", "text/html"),
        (".css", "text/css"),
        (".js", "application/javascript"),
        (".json", "application/json"),
        (".png", "image/png"),
        (".jpg", "image/jpeg"),
        (".jpeg", "image/jpeg"),
        (".gif", "image/gif"),
        (".svg", "image/svg+xml"),
        (".ico", "image/x-icon"),
        (".woff", "font/woff"),
        (".woff2", "font/woff2"),
        (".ttf", "font/ttf"),
        (".eot", "application/vnd.ms-fontobject"),
        (".otf", "font/otf"),
        (".xml", "application/xml"),
        (".txt", "text/plain"),
        (".csv", "text/csv"),
        (".mp4", "video/mp4"),
        (".webm", "video/webm"),
        (".ogg", "audio/ogg"),
        (".mp3", "audio/mpeg"),
        (".wav", "audio/wav"),
        (".zip", "application/zip"),
        (".tar", "application/x-tar"),
        (".pdf", "application/pdf")
    )
    
    public static func parse(file: String): ?String {
        if (let Some(index) <- file.lastIndexOf('.')) {
            let ext = file[index..file.size]
            if (MIME_TYPES.contains(ext)) {
                return MIME_TYPES[ext]
            }
        }
        return None
    }
}
