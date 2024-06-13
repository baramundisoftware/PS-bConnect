Function Remove-bConnectJobInstance() {
    <#
        .Synopsis
            Remove specified jobinstance.
        .Parameter JobInstanceGuid
            Valid GUID of a jobinstance.
        .Outputs
            Bool
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    [OutputType("System.Boolean")]
    Param (
        [Parameter(Mandatory=$true)][string]$JobInstanceGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        $_body = @{
            Id = $JobInstanceGuid
        }

        if($PSCmdlet.ShouldProcess($_body.Id, "Remove job instance from the database.")){
            return Invoke-bConnectDelete -Controller "JobInstances" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
