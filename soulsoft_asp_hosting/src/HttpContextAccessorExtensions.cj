package soulsoft_asp_hosting

public interface HttpContextAccessorExtensions {
    func addHttpContextAccessor(): ServiceCollection
}

extend ServiceCollection <: HttpContextAccessorExtensions{
    public func addHttpContextAccessor(): ServiceCollection {
        this.addScoped<IHttpContextAccessor, HttpContextAccessor>{_=> HttpContextAccessor()}
        return this
    }
}