Function Get-bConnectDynamicGroup() {
    <#
        .Synopsis
            Get specified Dynamic Group.
        .Parameter DynamicGroup
            Name (wildcards supported) or GUID of the Dynamic Group.
        .Parameter OrgUnit
            Valid GUID of a OrgUnit with Dynamic Groups
        .Outputs
            Array of DynamicGroup (see bConnect documentation for more details)
    #>

    Param(
        [string]$DynamicGroup,
        [string]$OrgUnit
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(![string]::IsNullOrEmpty($DynamicGroup)) {
            If(Test-Guid $DynamicGroup) {
                $_body = @{
                    Id = $DynamicGroup
                }

                return Invoke-bConnectGet -Controller "DynamicGroups" -Data $_body -Version $_connectVersion
            } else {
		# fetching dynamic groups with name is not supported; therefore we need a workaround for getting the specified dyn group...
		# Search available since bMS 2016R1
		$_groups = Search-bConnectDynamicGroup -Term $DynamicGroup
		$_ret_groups = @()
		Foreach($_grp in $_groups) {
			$_ret_groups += Get-bConnectDynamicGroup -DynamicGroup $_grp.Id
		}

		return $_ret_groups
		}
        } elseif (![string]::IsNullOrEmpty($OrgUnit)) {
            If(Test-Guid $OrgUnit) {
                $_body = @{
                    OrgUnit = $OrgUnit
                }

                return Invoke-bConnectGet -Controller "DynamicGroups" -Data $_body -Version $_connectVersion
            } else {
                return $false
            }
        } else {
            return Invoke-bConnectGet -Controller "DynamicGroups" -Version $_connectVersion
        }
    } else {
        return $false
    }
}
