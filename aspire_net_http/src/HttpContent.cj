package aspire_net_http

import std.io.*
import std.collection.*

public abstract class HttpContent {
    private let _headers = HttpContentHeaders()

    public prop headers: HttpContentHeaders {
        get() {
            _headers
        }
    }
   
    public func readAsStream(): InputStream
    
    public func readAsString(): String {
        StringReader(readAsStream()).readToEnd()
    }

    public func readAsByteArray(): Array<Byte> {
        let stream = readAsStream()
        let bytes = ArrayList<Byte>()
        let buffer = Array<Byte>(1024 * 1024 * 3, repeat: 0)
        while (true) {
            let size = stream.read(buffer)
            if (size > 0) {
               for (pattern in 0..size) {
                    bytes.add(buffer[pattern]) 
               }
            }else {
                break
            }
        }
        return bytes |> collectArray
    }
}