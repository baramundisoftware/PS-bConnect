Function Remove-bConnectInventoryDataRegistryScan() {
    <#
        .Synopsis
            Remove all registry scans from specified endpoint.
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

        if($PSCmdlet.ShouldProcess($_body.EndpointId, "Remove registry scan for endpoint from the database.")){
            return Invoke-bConnectDelete -Controller "InventoryDataRegistryScans" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
