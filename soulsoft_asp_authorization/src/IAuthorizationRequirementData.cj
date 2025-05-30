package soulsoft_asp_authorization


public interface IAuthorizationRequirementData {
    func getRequirements(): Collection<IAuthorizationRequirement>
}