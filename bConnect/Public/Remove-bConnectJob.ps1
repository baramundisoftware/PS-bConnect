Function Remove-bConnectJob() {
    <#
        .Synopsis
            Remove specified job.
        .Parameter EndpointGuid
            Valid GUID of a job.
        .Outputs
            Bool
    #>

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

        return Invoke-bConnectDelete -Controller "Jobs" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
