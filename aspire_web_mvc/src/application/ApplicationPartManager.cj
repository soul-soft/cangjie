package aspire_web_mvc.application

import std.collection.*

public class ApplicationPartManager {
    private let _parts = ArrayList<ApplicationPart>()
    private let _featureProviders = ArrayList<IApplicationFeatureProvider>()

    public init() {
    }

    public prop parts: List<ApplicationPart> {
        get() {
            _parts
        }
    }

    public prop featureProviders: List<IApplicationFeatureProvider> {
        get() {
            _featureProviders
        }
    }

    public func populateFeature<TFeature>(feature: TFeature) {
        for (pattern in _featureProviders |> filterMap {f => f as ApplicationFeatureProvider<TFeature>}) {
            pattern.populate(_parts, feature)
        }
    }
}
