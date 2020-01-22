Function Remove-bConnectJob() {
    <#
        .Synopsis
            Remove specified job.
        .Parameter EndpointGuid
            Valid GUID of a job.
        .Outputs
            Bool
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType("System.Boolean")]
    Param (
        [string]$JobGuid,
        [PSCustomObject]$Job
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(![string]::IsNullOrEmpty($JobGuid)) {
            $_body = @{
                Id = $JobGuid
            }
        } elseif (![string]::IsNullOrEmpty($Job.Id)) {
            $_body = @{
                Id = $Job.Id
            }
        } else {
            return $false
        }

        if($PSCmdlet.ShouldProcess($_body.Id, "Remove job and all associated data from the database.")){
            return Invoke-bConnectDelete -Controller "Jobs" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
