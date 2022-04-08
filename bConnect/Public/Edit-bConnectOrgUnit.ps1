Function Edit-bConnectOrgUnit() {
    <#
        .Synopsis
            Updates a existing OrgUnit.
        .Parameter OrgUnit
            Valid modified OrgUnit
        .Outputs
            OrgUnit (see bConnect documentation for more details).
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][PSCustomObject]$OrgUnit
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(Test-Guid $OrgUnit.Id) {
            $_orgUnit = ConvertTo-Hashtable $OrgUnit
            return Invoke-bConnectPatch -Controller "OrgUnits" -Version $_connectVersion -objectGuid $OrgUnit.Id -Data $_orgUnit
        } else {
            return $false
        }
    } else {
        return $false
    }
}
