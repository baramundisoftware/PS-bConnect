Function Get-bConnectInventoryOverview() {
    <#
        .Synopsis
            Get overview over all inventory scans.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            InventoryOverview (see bConnect documentation for more details).
    #>

    [CmdletBinding()]
    Param (
        [string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        If($EndpointGuid) {
            $_body = @{
                EndpointId = $EndpointGuid
            }
        }

        return Invoke-bConnectGet -Controller "InventoryOverviews" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
