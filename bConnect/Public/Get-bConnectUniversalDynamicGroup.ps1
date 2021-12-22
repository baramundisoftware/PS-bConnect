Function Get-bConnectUniversalDynamicGroup() {
    <#
        .Synopsis
            Get specified Universal Dynamic Group.
        .Parameter UniversalDynamicGroup
            GUID of the Universal Dynamic Group.
        .Parameter OrgUnit
            Valid GUID of a OrgUnit with Universal Dynamic Groups.
        .Parameter IsArgusSynced
            If true, only return Universal Dynamic Groups that are synced with Argus.
        .Outputs
            Array of Universal DynamicGroup (see bConnect documentation for more details).
    #>

    Param(
        [string]$UniversalDynamicGroup,
        [string]$OrgUnit,
        [switch]$IsArgusSynced
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{}

        if(![string]::IsNullOrEmpty($IsArgusSynced)) {
            $_body = @{
                IsArgusSynced = $IsArgusSynced
            }
        }

        If(![string]::IsNullOrEmpty($UniversalDynamicGroup)) {
            If(Test-Guid $UniversalDynamicGroup) {
                $_body += @{
                    Id = $UniversalDynamicGroup
                }

                return Invoke-bConnectGet -Controller "UniversalDynamicGroups" -Data $_body -Version $_connectVersion
            } else {
                return $false
		}
        } elseif (![string]::IsNullOrEmpty($OrgUnit)) {
            If(Test-Guid $OrgUnit) {
                $_body += @{
                    OrgUnit = $OrgUnit
                }

                return Invoke-bConnectGet -Controller "UniversalDynamicGroups" -Data $_body -Version $_connectVersion
            } else {
                return $false
            }
        } else {
            return Invoke-bConnectGet -Controller "UniversalDynamicGroups" -Data $_body -Version $_connectVersion
        }
    } else {
        return $false
    }
}
