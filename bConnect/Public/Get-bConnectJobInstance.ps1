Function Get-bConnectJobInstance() {
    <#
        .Synopsis
            Get specified jobinstance by GUID, all jobinstances of a job or all jobinstances on a endpoint.
        .Parameter JobInstanceGuid
            Valid GUID of a jobinstance.
        .Parameter JobGuid
            Valid GUID of a job.
        .Parameter EndpointGuid
            Valid GUID of a endpoint
        .Parameter Username
            Valid Username (in combination with EndpointGuid)
        .Outputs
            Array of JobInstance (see bConnect documentation for more details).
    #>

    Param (
        [string]$JobInstanceGuid,
        [string]$JobGuid,
        [string]$EndpointGuid,
        [string]$Username
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($JobGuid) {
            $_body = @{
                JobId = $JobGuid
            }
        }

        If($EndpointGuid) {
            $_body = @{
                EndpointId = $EndpointGuid
            }
        }

        If($JobInstanceGuid) {
            $_body = @{
                Id = $JobInstanceGuid
            }
        }

        If($Username -and $EndpointGuid) {
            $_body = @{
                User = $Username
                EndpointId = $EndpointGuid
            }
        }

        return Invoke-bConnectGet -Controller "JobInstances" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
