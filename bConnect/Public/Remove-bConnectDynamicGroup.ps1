Function Remove-bConnectDynamicGroup() {
    <#
        .Synopsis
            Remove specified DynamicGroup.
        .Parameter DynamicGroupGuid
            Valid GUID of a DynamicGroup.
        .Outputs
            Bool
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType("System.Boolean")]
    Param (
        [Parameter(Mandatory=$true)][string]$DynamicGroupGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        $_body = @{
            Id = $DynamicGroupGuid
        }

        if($PSCmdlet.ShouldProcess($_body.Id, "Remove dynamic group from the database.")){
            return Invoke-bConnectDelete -Controller "DynamicGroups" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
