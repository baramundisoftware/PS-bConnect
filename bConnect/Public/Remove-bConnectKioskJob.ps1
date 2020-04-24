Function Remove-bConnectKioskJob() {
    <#
        .Synopsis
            Remove specified kiosk job.
        .Parameter EndpointGuid
            Valid GUID of a kiosk job.
        .Outputs
            Bool
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType("System.Boolean")]
    Param (
        [string]$KioskJobId,
        [PSCustomObject]$KioskJob
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(![string]::IsNullOrEmpty($KioskJobId)) {
            $_body = @{
                KioskJobId = $KioskJobId
            }
        } elseif (![string]::IsNullOrEmpty($Job.Id)) {
            $_body = @{
                KioskJobId = $KioskJob.Id
            }
        } else {
            return $false
        }

        if($PSCmdlet.ShouldProcess($_body.Id, "Revoke the release for this object.")){
            return Invoke-bConnectDelete -Controller "KioskJobs" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
