Function Get-bConnectSoftwareScanRule() {
    <#
        .Synopsis
            Get all software scan rules.
        .Outputs
            SoftwareScanRule (see bConnect documentation for more details).
    #>

    [CmdletBinding()]
    Param ()

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {

        return Invoke-bConnectGet -Controller "SoftwareScanRules" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
