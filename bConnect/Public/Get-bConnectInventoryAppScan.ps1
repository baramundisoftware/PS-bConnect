Function Get-bConnectInventoryAppScan() {
    <#
        .Synopsis
            Get app inventory data for mobile endpoints.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            InventoryApp (see bConnect documentation for more details).
    #>

    Param (
        [string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($EndpointGuid) {
            $_body = @{
                EndpointId = $EndpointGuid
            }
        }

        return Invoke-bConnectGet -Controller "InventoryAppScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
