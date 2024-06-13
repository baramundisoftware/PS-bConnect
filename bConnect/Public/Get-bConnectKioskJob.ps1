Function Get-bConnectKioskJob() {
    <#
        .Synopsis
            Get Kiosk releases based on User, Endpoint, Group or Job.
        .Parameter User
            Valid Username (Principal Name).
        .Parameter EndpointpId
            Valid GUID of an Endpoint.
        .Parameter GroupId
            Valid GUID of a Orgunit.
        .Parameter JobDefinitionId
            Valid GUID of an job.
        .Outputs
            Array of KioskJob (see bConnect documentation for more details).
    #>

    [CmdletBinding()]
    Param (
        [string]$Username,
        [string]$EndpointId,
        [string]$GroupId,
        [string]$JobDefinitionId
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        If($Username) {
            $_body = @{
                User = $Username
            }
        }

        If($EndpointId) {
            $_body = @{
                EndpointId = $EndpointId
            }
        }

        If($GroupId) {
            $_body = @{
                GroupId = $GroupId
            }
        }

        If($JobDefinitionId) {
            $_body += @{
                JobDefinitionId = $JobDefinitionId
            }
        }

        return Invoke-bConnectGet -Controller "KioskJobs" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
