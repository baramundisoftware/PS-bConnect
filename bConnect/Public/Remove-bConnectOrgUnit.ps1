Function Remove-bConnectOrgUnit() {
    <#
        .Synopsis
            Remove specified OrgUnit.
        .Parameter OrgUnitGuid
            Valid GUID of a OrgUnit.
        .Outputs
            Bool
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType("System.Boolean")]
    Param (
        [Parameter(Mandatory=$true)][string]$OrgUnitGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $OrgUnitGuid
        }

        if($PSCmdlet.ShouldProcess($_body.Id, "Remove org unit and all associated data from the database.")){
            return Invoke-bConnectDelete -Controller "OrgUnits" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
