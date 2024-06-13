Function Get-bConnectEndpointSecret() {
    <#
        .Synopsis
            Get disk encryption information for specified endpoint.
        .Parameter EndpointId
            Valid GUID of an endpoint.
        .Outputs
            Array of EndpointSecrets (see bConnect documentation for more details).
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        $_body = @{
            EndpointId = $EndpointGuid
        }

        return Invoke-bConnectGet -Controller "EndpointSecrets" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
