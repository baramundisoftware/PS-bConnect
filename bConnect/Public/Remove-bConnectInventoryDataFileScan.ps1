Function Remove-bConnectInventoryDataFileScan() {
    <#
        .Synopsis
            Remove all file scans from specified endpoint.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            Bool
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            EndpointId = $EndpointGuid;
        }
        return Invoke-bConnectDelete -Controller "InventoryDataFileScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
