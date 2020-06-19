Function Edit-bConnectJob() {
    <#
        .Synopsis
            Updates a existing job.
        .Parameter Job
            Job object (hashtable).
        .Outputs
            Job (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][PSCustomObject]$Job,
        [boolean]$IgnoreAssignments = $false

    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(Test-Guid $Job.Id) {
            $_Job = ConvertTo-Hashtable $Job
            return Invoke-bConnectPatch -Controller "Jobs" -Version $_connectVersion -objectGuid $_Job.Id -Data $_Job -IgnoreAssignments $IgnoreAssignments
        } else {
            return $false
        }
    } else {
        return $false
    }
}
