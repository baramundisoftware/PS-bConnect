Function Get-bConnectInventoryDataCustomScan() {
    <#
        .Synopsis
            Get custom scans.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Parameter TemplateName
            Valid name of a inventory template
        .Parameter ScanTerm
            "latest" or specified as UTC time in the format “yyyy-MM-ddThh:mm:ssZ” (y=year, M=month, d=day, h=hours, m=minutes, s=seconds).
        .Outputs
            Inventory (see bConnect documentation for more details).
    #>

    [CmdletBinding()]
    Param (
        [string]$EndpointGuid,
        [string]$TemplateName,
        [string]$ScanTerm
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        $_body = @{}
        If($EndpointGuid) {
            $_body += @{ EndpointId = $EndpointGuid }
        }
        If($TemplateName) {
            $_body += @{ TemplateName = $TemplateName }
        }
        If($ScanTerm) {
            $_body += @{ Scan = $ScanTerm }
        }

        return Invoke-bConnectGet -Controller "InventoryDataCustomScans" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
