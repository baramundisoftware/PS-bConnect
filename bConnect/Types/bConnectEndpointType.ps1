# enum for Endpoint types
Add-Type -TypeDefinition @"
public enum bConnectEndpointType
{
    Unknown = 0,
    WindowsEndpoint = 1,
    AndroidEndpoint = 2,
    iOSEndpoint = 3,
    MacEndpoint = 4,
    WindowsPhoneEndpoint = 5,
    NetworkEndpoint = 16
}
"@