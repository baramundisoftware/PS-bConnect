Function Resume-bConnectJobInstance() {
    <#
        .Synopsis
            Resume the specified jobinstance.
        .Parameter JobInstanceGuid
            Valid GUID of a jobinstance.
        .Outputs
            Bool
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType("System.Boolean")]
    Param (
        [string]$JobInstanceGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        $_body = @{
            Id = $JobInstanceGuid;
            Cmd = "resume"
        }

        if($PSCmdlet.ShouldProcess($_body.Id, "Resume job instance.")){
            return Invoke-bConnectGet -Controller "JobInstances" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
