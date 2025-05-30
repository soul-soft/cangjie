package soulsoft_extensions_injection

/*
服务生命周期
 */
public enum ServiceLifetime <: ToString {
    Singleton | Scoped | Transient

    public func isScoped() {
        match (this) {
            case Scoped => true
            case _ => false
        }
    }

    public func isTransient() {
        match (this) {
            case Transient => true
            case _ => false
        }
    }

    public func isSingleton() {
        match (this) {
            case Singleton => true
            case _ => false
        }
    }

    public func toString() {
        return match (this) {
            case Singleton => "Singleton"
            case Scoped => "Scoped"
            case Transient => "Transient"
        }
    }
}
