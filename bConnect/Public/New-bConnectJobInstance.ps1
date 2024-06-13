Function New-bConnectJobInstance() {
    <#
        .Synopsis
            Assign the specified job to a endpoint.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Parameter JobGuid
            Valid GUID of a job.
        .Parameter StartIfExists
            Restart the existing jobinstance if there is one.
        .Parameter Initiator
            Set the Initiator of the new job instance.
        .Outputs
            JobInstance (see bConnect documentation for more details).
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    [OutputType("System.Management.Automations.PSObject","System.Boolean")]
    Param (
        [Parameter(Mandatory=$true)][string]$EndpointGuid,
        [Parameter(Mandatory=$true)][string]$JobGuid,
        [string]$Initiator,
        [switch]$StartIfExists
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        $_body = @{
            EndpointId = $EndpointGuid;
            JobId = $JobGuid;
            StartIfExists = $StartIfExists.ToString()
        }

        If($JobInstanceGuid) {
            $_body += @{
                Initiator = $Initiator
            }
        }

        if($PSCmdlet.ShouldProcess($_body.EndpointId, "Create new job instance.")){
            return Invoke-bConnectGet -Controller "JobInstances" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
