Function Remove-bConnectEndpoint() {
    <#
        .Synopsis
            Remove specified endpoint.
        .Parameter EndpointGuid
            Valid GUID of an endpoint.
        .Parameter Endpoint
            Valid Endpoint object.
        .Outputs
            Bool
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType("System.Boolean")]
    Param (
        [string]$EndpointGuid,
        [PSCustomObject]$Endpoint
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(![string]::IsNullOrEmpty($EndpointGuid)) {
            $_body = @{
                Id = $EndpointGuid
            }
        } elseif (![string]::IsNullOrEmpty($Endpoint.Id)) {
            $_body = @{
                Id = $Endpoint.Id
            }
        } else {
            return $false
        }

        if($PSCmdlet.ShouldProcess($_body.Id, "Remove endpoint and all associated data from the database.")){
            return Invoke-bConnectDelete -Controller "Endpoints" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
