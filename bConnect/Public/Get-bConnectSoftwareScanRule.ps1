Function Get-bConnectSoftwareScanRule() {
    <#
        .Synopsis
            Get all software scan rules.
        .Outputs
            SoftwareScanRule (see bConnect documentation for more details).
    #>

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {

        return Invoke-bConnectGet -Controller "SoftwareScanRules" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
