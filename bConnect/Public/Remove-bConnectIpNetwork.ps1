Function Remove-bConnectIpNetwork() {
    <#
        .Synopsis
            Remove specified IpNetwork.
        .Parameter IpNetworkGuid
            Valid GUID of a IpNetwork.
        .Parameter IpNetwork
            Valid IpNetwork Object.
        .Outputs
            Bool
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium', DefaultParameterSetName = 'Guid')]
    [OutputType("System.Boolean")]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Guid')]
        [string]$IpNetworkGuid,
        [Parameter(Mandatory = $true, ParameterSetName = 'Object')]
        [PSCustomObject]$IpNetwork
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(![string]::IsNullOrEmpty($IpNetworkGuid)) {
            $_body = @{
                Id = $IpNetworkGuid
            }
        } elseif (![string]::IsNullOrEmpty($IpNetwork.Id)) {
            $_body = @{
                Id = $IpNetwork.Id
            }
        } else {
            return $false
        }

        if($PSCmdlet.ShouldProcess($_body.Id, "Remove IpNetwork and all associated data from the database.")){
            return Invoke-bConnectDelete -Controller "IpNetworks" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
