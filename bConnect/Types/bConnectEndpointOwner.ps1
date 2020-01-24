# enum for Endpoint owner
Add-Type -TypeDefinition @"
public enum bConnectEndpointOwner
{
    Unknown = -2,
    Company = 0,
    Private = 1
}
"@