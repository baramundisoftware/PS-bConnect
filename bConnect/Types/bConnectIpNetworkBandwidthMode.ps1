# enum for Bandwidth mode
Add-Type -TypeDefinition @"
public enum bConnectIpNetworkBandwidthMode
{
    AllowAll = 0,
    BlockAll = 1,
    UseBandwidth = 2
}
"@
