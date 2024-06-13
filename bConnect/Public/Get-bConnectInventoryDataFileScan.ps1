Function Get-bConnectInventoryDataFileScan() {
    <#
        .Synopsis
            Get file scans.
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
    If($_connectVersion -ge "v1.0") {
        If($EndpointGuid) {
            $_body = @{
                EndpointId = $EndpointGuid
            }
        }

        return Invoke-bConnectGet -Controller "InventoryDataFileScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
