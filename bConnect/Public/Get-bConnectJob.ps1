Function Get-bConnectJob() {
    <#
        .Synopsis
            Get specified job or all jobs in given OrgUnit.
        .Parameter JobGuid
            Valid GUID of a job.
        .Parameter OrgUnitGuid
            Valid GUID of a Orgunit.
        .Parameter Username
            Valid Username.
        .Outputs
            Array of Job (see bConnect documentation for more details).
    #>

    Param (
        [string]$JobGuid,
        [string]$OrgUnitGuid,
        [string]$Username,
        [switch]$Steps
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($JobGuid) {
            $_body = @{
                Id = $JobGuid
            }
        }

        If($OrgUnitGuid) {
            $_body = @{
                OrgUnit = $OrgUnitGuid
            }
        }

        If($Username) {
            $_body = @{
                User = $Username
            }
        }

        If($Steps) {
            $_body += @{
                Steps = $true
            }
        }

        return Invoke-bConnectGet -Controller "Jobs" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
