Function New-bConnectKioskJob() {
    <#
        .Synopsis
            Release an job for an endpoint, group or user.
        .Parameter JobDefinitionId
            Valid GUID of an job.
        .Parameter TargetId
            Valid GUID of an endpoint, group or user.
        .Parameter Username
            Valid Username (Principal Name).
            If set, Username replaces TargetId.
        .Outputs
            Boolean
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    [OutputType("System.Management.Automations.PSObject","System.Boolean")]
    Param (
        [Parameter(Mandatory=$true)][string]$JobDefinitionId,
        [string]$TargetId,
        [string]$Username
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        $_body = @{
            JobDefinitionId = $JobDefinitionId;
        }

        If($Username) {
            $_body += @{
                User = $Username
            }
        } else {
            If($TargetId) {
                $_body += @{
                    TargetId = $TargetId
                }
            }
        }

        if($PSCmdlet.ShouldProcess($_body.EndpointId, "Release the job for specified target.")){
            return Invoke-bConnectPost -Controller "KioskJobs" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
