# enum for EndpointComplianceState
Add-Type -TypeDefinition @"
public enum bConnectEndpointComplianceState
{
    Unknown = 0,
    Compliant = 1,
    NotCompliantInfo = 2,
    NotCompliantWarning = 3,
    NotCompliantSevere = 4,
    ComplianceInactive = 5
}
"@