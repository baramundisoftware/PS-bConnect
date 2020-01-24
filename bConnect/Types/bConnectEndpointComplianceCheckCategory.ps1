# enum for Endpoint ComplianceCheckCategory
Add-Type -TypeDefinition @"
public enum bConnectEndpointComplianceCheckCategory
{
    Active = 0,
    Inactive = 1,
    TemporarilyInactive = 2
}
"@