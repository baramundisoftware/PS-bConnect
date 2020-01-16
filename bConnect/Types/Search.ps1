# enum for SearchResult types
Add-Type -TypeDefinition @"
public enum bConnectSearchResultType
{
    Unknown = 0,
    WindowsEndpoint = 1,
    AndroidEndpoint = 2,
    iOSEndpoint = 3,
    MacEndpoint = 4,
    WindowsPhoneEndpoint = 5,
    WindowsJob = 6,
    BmsNetJob = 7,
	OrgUnit = 8,
	DynamicGroup = 9,
	StaticGroup = 10,
    Application = 11,
    App = 12,
    NetworkEndpoint = 16
}
"@