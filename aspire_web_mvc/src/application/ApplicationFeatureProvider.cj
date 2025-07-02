package aspire_web_mvc.application

public abstract class ApplicationFeatureProvider<TFeature> <: IApplicationFeatureProvider {
    public func populate(parts: Collection<ApplicationPart>, feature: TFeature): Unit
}