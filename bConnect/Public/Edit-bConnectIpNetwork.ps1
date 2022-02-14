Function Edit-bConnectIpNetwork() {
    <#
        .Synopsis
            Updates a existing Ip Network.
        .Parameter IpNetwork
            Ip Network object (hashtable).
        .Outputs
            Ip Network (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][PSCustomObject]$IpNetwork

    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(Test-Guid $IpNetwork.Id) {
            $_IpNetwork = ConvertTo-Hashtable $IpNetwork
            return Invoke-bConnectPatch -Controller "IpNetworks" -Version $_connectVersion -objectGuid $_IpNetwork.Id -Data $_IpNetwork
        } else {
            return $false
        }
    } else {
        return $false
    }
}
