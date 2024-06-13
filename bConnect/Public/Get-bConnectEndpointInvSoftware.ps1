Function Get-bConnectEndpointInvSoftware() {
    <#
        .Synopsis
            Get all links between endpoints and software scan rules.
        .Outputs
            EndpointInvSoftware (see bConnect documentation for more details).
    #>
    
    [CmdletBinding()]
    Param ()

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {

        return Invoke-bConnectGet -Controller "EndpointInvSoftware" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
