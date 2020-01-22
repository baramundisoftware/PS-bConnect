Function Remove-bConnectOrgUnit() {
    <#
        .Synopsis
            Remove specified OrgUnit.
        .Parameter OrgUnitGuid
            Valid GUID of a OrgUnit.
        .Outputs
            Bool
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$OrgUnitGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $OrgUnitGuid
        }

        return Invoke-bConnectDelete -Controller "OrgUnits" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
