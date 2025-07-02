package aspire_extensions_caching

import std.time.*

public class DistributedCacheEntryOptions {
    private var _slidingExpiration: ? Duration = None
    private var _absoluteExpiration: ? DateTime = None
    private var _absoluteExpirationRelativeToNow:? Duration = None


    public mut prop slidingExpiration: ?Duration{
        get() {
            _slidingExpiration
        }
        set(value) {
            _slidingExpiration = value
        }
    }

    public mut prop absoluteExpiration: ?DateTime{
        get() {
            _absoluteExpiration
        }
        set(value) {
            _absoluteExpiration = value
        }
    }

     public mut prop absoluteExpirationRelativeToNow: ?Duration{
        get() {
            _absoluteExpirationRelativeToNow
        }
        set(value) {
            _absoluteExpirationRelativeToNow = value
        }
    }
}