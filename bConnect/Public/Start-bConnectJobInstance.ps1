Function Start-bConnectJobInstance() {
    <#
        .Synopsis
            Start the specified jobinstance.
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
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $JobInstanceGuid;
            Cmd = "start"
        }

        if($PSCmdlet.ShouldProcess($_body.Id, "Start job instance.")){
            return Invoke-bConnectGet -Controller "JobInstances" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
