Function Get-bConnectIpNetwork() {
    <#
        .Synopsis
            Get Ip Network based on Name or Id.
        .Parameter Name
            Valid Ip Network Name.
        .Parameter Id
            Valid GUID of an Ip Network.
        .Outputs
            Array of IpNetworks (see bConnect documentation for more details).
    #>

    [CmdletBinding()]
    Param (
        [string]$Name,
        [string]$Id
        )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($Name) {
            $_body = @{
                Name = $Name
            }
        }

        If($Id) {
            $_body = @{
                Id = $Id
            }
        }

        return Invoke-bConnectGet -Controller "IpNetworks" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
