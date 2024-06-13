Function Get-bConnectStaticGroup() {
    <#
        .Synopsis
            Get specified Static Group.
        .Parameter StaticGroup
            Name (wildcards supported) or GUID of the Static Group.
        .Parameter OrgUnit
            Valid GUID of a OrgUnit with Static Groups
        .Outputs
            Array of StaticGroup (see bConnect documentation for more details)
    #>
    
    [CmdletBinding()]
    Param(
        [string]$StaticGroup,
        [string]$OrgUnit
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        If(![string]::IsNullOrEmpty($StaticGroup)) {
            If(Test-Guid $StaticGroup) {
                $_body = @{
                    Id = $StaticGroup
                }

                return Invoke-bConnectGet -Controller "StaticGroups" -Data $_body -Version $_connectVersion
            } else {
			    # fetching static groups with name is not supported; therefore we need a workaround for getting the specified static group...
			    $_bmsVersion = Get-bConnectInfo
                If($_bmsVersion.bMSVersion -imatch "16.*") {
				    # Search available since bMS 2016R1
				    $_groups = Search-bConnectStaticGroup -Term $StaticGroup
                    $_ret_groups = @()
                    Foreach($_grp in $_groups) {
                        $_ret_groups += Get-bConnectStaticGroup -StaticGroup $_grp.Id
                    }

				    return $_ret_groups
	            }
                return $false
		    }
        } elseif (![string]::IsNullOrEmpty($OrgUnit)) {
            If(Test-Guid $OrgUnit) {
                $_body = @{
                    OrgUnit = $OrgUnit
                }

                return Invoke-bConnectGet -Controller "StaticGroups" -Data $_body -Version $_connectVersion
            } else {
                return $false
            }
        } else {
            return Invoke-bConnectGet -Controller "StaticGroups" -Version $_connectVersion
        }
    } else {
        return $false
    }
}
