Function Remove-bConnectInventoryDataFileScan() {
    <#
        .Synopsis
            Remove all file scans from specified endpoint.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            Bool
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    [OutputType("System.Boolean")]
    Param (
        [Parameter(Mandatory=$true)][string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        $_body = @{
            EndpointId = $EndpointGuid;
        }

        if($PSCmdlet.ShouldProcess($_body.EndpointId, "Remove file scan for endpoint from the database.")){
            return Invoke-bConnectDelete -Controller "InventoryDataFileScans" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
