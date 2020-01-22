Function Remove-bConnectApplication() {
    <#
        .Synopsis
            Remove specified application.
        .Parameter ApplicationGuid
            Valid GUID of a application.
        .Parameter Application
            Valid Application object
        .Outputs
            Bool
    #>

    Param (
        [string]$ApplicationGuid,
        [PSCustomObject]$Application
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(![string]::IsNullOrEmpty($ApplicationGuid)) {
            $_body = @{
                Id = $ApplicationGuid
            }
        } elseif (![string]::IsNullOrEmpty($Application.Id)) {
            $_body = @{
                Id = $Application.Id
            }
        } else {
            return $false
        }

        return Invoke-bConnectDelete -Controller "Applications" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
