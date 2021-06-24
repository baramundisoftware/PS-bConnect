# enum for Bandwidth mode
Add-Type -TypeDefinition @"
public enum bConnectIpNetworkBandwidthMode
{
    AllowAll = 0,
    DenyAll = 1,
    UseBandwith = 2
}
"@