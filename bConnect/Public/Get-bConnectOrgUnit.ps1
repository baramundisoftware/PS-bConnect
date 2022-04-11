Function Get-bConnectOrgUnit() {
    <#
        .Synopsis
            Get specified OrgUnit.
        .Parameter OrgUnit
            Name (wildcards supported) or GUID of the OrgUnit.
        .Parameter SubGroups
            List subgroups of given OrgUnit.
            Only used if parameter "name" is a valid GUID.
        .Outputs
            Array of OrgUnit (see bConnect documentation for more details)
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)][string]$OrgUnit,
        [switch]$SubGroups
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(Test-Guid $OrgUnit) {
            If($SubGroups) {
                $_body = @{
                    OrgUnit = $OrgUnit
                }
            } else {
                $_body = @{
                    Id = $OrgUnit
                }
            }

            return Invoke-bConnectGet -Controller "OrgUnits" -Data $_body -Version $_connectVersion
        } else {
			# fetching orgunits with name is not supported; therefore we need a workaround for getting the specified orgunit...
			$_bmsVersion = Get-bConnectInfo
            If($_bmsVersion.bMSVersion -imatch "16.*") {
				# Search available since bMS 2016R1
				$_groups = Search-bConnectOrgUnit -Term $OrgUnit

				return $_groups
			} else {
	           	# no search, so keep looping ;)
            	$_groups = Invoke-bConnectGet -Controller "OrgUnits" -Version $_connectVersion
	            $_ret = @()
    	        Foreach($_group in $_groups) {
        	        If($_group.Name -match $orgUnit) {
            	        $_ret += $_group
                	}
	            }

    	        return $_ret
	        }
		}
    } else {
        return $false
    }
}
