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

        return Invoke-bConnectDelete -Controller "Endpoints" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
