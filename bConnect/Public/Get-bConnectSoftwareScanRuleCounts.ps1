Function Get-bConnectSoftwareScanRuleCounts() {
    <#
        .Synopsis
            Get all software scan rule counts.
        .Outputs
            SoftwareScanRuleCount (see bConnect documentation for more details).
    #>

    [CmdletBinding()]
    Param ()

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {

        return Invoke-bConnectGet -Controller "SoftwareScanRuleCounts" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
