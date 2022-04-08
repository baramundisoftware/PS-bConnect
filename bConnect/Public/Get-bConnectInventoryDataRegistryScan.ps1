Function Get-bConnectInventoryDataRegistryScan() {
    <#
        .Synopsis
            Get registry scans.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            Inventory (see bConnect documentation for more details).
    #>

    [CmdletBinding()]
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

        return Invoke-bConnectGet -Controller "InventoryDataRegistryScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
