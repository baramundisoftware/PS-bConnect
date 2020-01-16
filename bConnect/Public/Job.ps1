#--- Job ---
Function Search-bConnectJob() {
    <#
        .Synopsis
            Search for specified jobs.
        .Parameter Term
            Searchterm for the search. Wildcards allowed.
        .Outputs
            Array of SearchResult (see bConnect documentation for more details)
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$Term
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Type = "job";
            Term = $Term
        }

        return Invoke-bConnectGet -Controller "Search" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

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

Export-ModuleMember Search-bConnectJob
Export-ModuleMember Get-bConnectJob
Export-ModuleMember Remove-bConnectJob
