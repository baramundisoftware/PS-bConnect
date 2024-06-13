Function Set-bConnectEndpointSecret() {
    <#
        .Synopsis
            Set disk encryption information for specified endpoint.
        .Parameter EndpointId
            Valid GUID of an endpoint.
        .Parameter Pin
            Current unlock pin for endpoint.
        .Outputs
            Boolean.
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    [OutputType("System.Boolean")]
    Param (
        [Parameter(Mandatory=$true)][string]$EndpointGuid,
        [Parameter(Mandatory=$true)][string]$Pin
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        $_body = @{
            EndpointId = $EndpointGuid;
            Pin = $Pin
        }

        if($PSCmdlet.ShouldProcess($_body.Name, "Set unlock PIN for endpoint.")){
            return Invoke-bConnectPatch -Controller "EndpointSecrets" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
