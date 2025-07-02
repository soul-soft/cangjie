package aspire_web_authorization


public interface IAuthorizationRequirementData {
    func getRequirements(): Collection<IAuthorizationRequirement>
}