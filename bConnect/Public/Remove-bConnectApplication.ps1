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

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType("System.Boolean")]
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

        if($PSCmdlet.ShouldProcess($_body.Id, "Remove application and all associated data from the database.")){
            return Invoke-bConnectDelete -Controller "Applications" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
