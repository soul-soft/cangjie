package soulsoft_web_authorization


public interface IAuthorizationRequirementData {
    func getRequirements(): Collection<IAuthorizationRequirement>
}