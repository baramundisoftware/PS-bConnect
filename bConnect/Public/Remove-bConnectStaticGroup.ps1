Function Remove-bConnectStaticGroup() {
    <#
        .Synopsis
            Remove specified StaticGroup.
        .Parameter StaticGroupGuid
            Valid GUID of a StaticGroup.
        .Outputs
            Bool
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType("System.Boolean")]
    Param (
        [Parameter(Mandatory=$true)][string]$StaticGroupGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $StaticGroupGuid
        }

        if($PSCmdlet.ShouldProcess($_body.Id, "Remove static group from the database.")){
            return Invoke-bConnectDelete -Controller "StaticGroups" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
