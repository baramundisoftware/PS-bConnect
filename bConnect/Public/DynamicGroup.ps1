#--- Dynamic Group ---
Function Search-bConnectDynamicGroup() {
    <#
        .Synopsis
            Search for specified static group.
        .Parameter Term
            Searchterm for the search. Wildcards allowed.
        .Outputs
            Array of SearchResult (see bConnect documentation for more details)
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$Term
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Type = "group";
            Term = $Term
        }

        $_groups = Invoke-bConnectGet -Controller "Search" -Version $_connectVersion -Data $_body
        $_result = @()
        Foreach($_group in $_groups) {
            If($_group.Type -eq [bConnectSearchResultType]::DynamicGroup) {
                $_result += $_group
            }
        }
        return $_result
    } else {
        return $false
    }
}

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
			    $_bmsVersion = Get-bConnectInfo
                If($_bmsVersion.bMSVersion -imatch "16.*") {
				    # Search available since bMS 2016R1
				    $_groups = Search-bConnectDynamicGroup -Term $DynamicGroup
                    $_ret_groups = @()
                    Foreach($_grp in $_groups) {
                        $_ret_groups += Get-bConnectDynamicGroup -DynamicGroup $_grp.Id
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

Function New-bConnectDynamicGroup() {
    <#
        .Synopsis
            Create a new DynamicGroup.
        .Parameter Name
            Name of the DynamicGroup.
        .Parameter ParentGuid
            Valid GUID of the parent OrgUnit in hierarchy (default: "Dynamic Groups").
        .Parameter Statement
            Valid SQL Statement ("SELECT * FROM machine " will be automatically added).
        .Parameter Comment
            Comment for the DynamicGroup.
        .Outputs
            DynamicGroup (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][string]$Name,
        [string]$ParentGuid = "BDE918DC-89C0-458A-92F7-0BB9147A2706", #guid of "Dynamic Groups" as fallback
        [Parameter(Mandatory=$true)][string]$Statement,
		[string]$Comment
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Name = $Name;
            ParentId = $ParentGuid;
        }

		If($Statement -imatch "WHERE") {
			$_body += @{ Statement = $Statement }
		} else {
            return $false
        }

		If(![string]::IsNullOrEmpty($Comment)) {
			$_body += @{ Comment = $Comment }
		}

        return Invoke-bConnectPost -Controller "DynamicGroups" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Remove-bConnectDynamicGroup() {
    <#
        .Synopsis
            Remove specified DynamicGroup.
        .Parameter DynamicGroupGuid
            Valid GUID of a DynamicGroup.
        .Outputs
            Bool
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$DynamicGroupGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $DynamicGroupGuid
        }

        return Invoke-bConnectDelete -Controller "DynamicGroups" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Edit-bConnectDynamicGroup() {
    <#
        .Synopsis
            Updates a existing DynamicGroup.
        .Parameter DynamicGroup
            Valid modified DynamicGroup
        .Outputs
            DynamicGroup (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][PSCustomObject]$DynamicGroup
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(Test-Guid $DynamicGroup.Id) {
            # bms2016r1
            # We can not send the whole object because of not editable fields.
            # So we need to create a new one with editable fields only...
			# And as this might be too easy we face another problem: we are only allowed to send the changed fields :(
			# Dirty workaround: reload the object and compare new vs. old
			$_old_group = Get-bConnectDynamicGroup -DynamicGroup $DynamicGroup.Id
			$_old_group = ConvertTo-Hashtable $_old_group

            $_new_group = @{ Id = $DynamicGroup.Id }
			$_propertyList = @(
                "ParentId",
                "Name",
                "Statement",
                "Comment"
            )
            $DynamicGroup = ConvertTo-Hashtable $DynamicGroup

			Foreach($_property in $_propertyList) {
                If($DynamicGroup[$_property] -ine $_old_group[$_property]) {
                    $_new_group += @{ $_property = $DynamicGroup[$_property] }
                }
			}

            #Workaround for a bug in bConnect 2016r1
            # we need to assign the property "Name" even if it is unchanged.
            # otherwise the controller returns an error...
            If($_new_group.Keys -notcontains "Name") {
                $_new_group += @{ "Name" = $DynamicGroup["Name"] }
            }

            return Invoke-bConnectPatch -Controller "DynamicGroups" -Version $_connectVersion -objectGuid $DynamicGroup.Id -Data $_new_group
        } else {
            return $false
        }
    } else {
        return $false
    }
}

Export-ModuleMember Search-bConnectDynamicGroup
Export-ModuleMember Get-bConnectDynamicGroup
Export-ModuleMember New-bConnectDynamicGroup
Export-ModuleMember Remove-bConnectDynamicGroup
Export-ModuleMember Edit-bConnectDynamicGroup