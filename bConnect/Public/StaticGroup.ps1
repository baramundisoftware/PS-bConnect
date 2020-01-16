#--- Static Group ---
Function Search-bConnectStaticGroup() {
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
            If($_group.Type -eq [bConnectSearchResultType]::StaticGroup) {
                $_result += $_group
            }
        }
        return $_result
    } else {
        return $false
    }
}

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

    Param(
        [string]$StaticGroup,
        [string]$OrgUnit
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
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

Function New-bConnectStaticGroup() {
    <#
        .Synopsis
            Create a new StaticGroup.
        .Parameter Name
            Name of the StaticGroup.
        .Parameter ParentGuid
            Valid GUID of the parent OrgUnit in hierarchy (default: "Static Groups").
        .Parameter Endpoints
            Array of Endpoints.
        .Parameter Comment
            Comment for the StaticGroup.
        .Outputs
            StaticGroup (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][string]$Name,
        [string]$ParentGuid = "5020494B-04D3-4654-A256-80731E953746", #guid of "Static Groups" as fallback
        [PSCustomObject[]]$Statement,
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
        }

		If(![string]::IsNullOrEmpty($Comment)) {
			$_body += @{ Comment = $Comment }
		}

        return Invoke-bConnectPost -Controller "StaticGroups" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Remove-bConnectStaticGroup() {
    <#
        .Synopsis
            Remove specified StaticGroup.
        .Parameter StaticGroupGuid
            Valid GUID of a StaticGroup.
        .Outputs
            Bool
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$StaticGroupGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $StaticGroupGuid
        }

        return Invoke-bConnectDelete -Controller "StaticGroups" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Edit-bConnectStaticGroup() {
    <#
        .Synopsis
            Updates a existing StaticGroup.
        .Parameter StaticGroup
            Valid modified StaticGroup
        .Outputs
            StaticGroup (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][PSCustomObject]$StaticGroup
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(Test-Guid $StaticGroup.Id) {
            # bms2016r1
            # We can not send the whole object because of not editable fields.
            # So we need to create a new one with editable fields only...
			# And as this might be too easy we face another problem: we are only allowed to send the changed fields :(
			# Dirty workaround: reload the object and compare new vs. old
			$_old_group = Get-bConnectStaticGroup -StaticGroup $StaticGroup.Id
			$_old_group = ConvertTo-Hashtable $_old_group

            $_new_group = @{ Id = $StaticGroup.Id }
			$_propertyList = @(
                "ParentId",
                "Name",
                "EndpointIds",
                "Comment"
            )
            $StaticGroup = ConvertTo-Hashtable $StaticGroup

            $_endpointIds = @()
            Foreach($_ep in $StaticGroup.EndpointIds) {
                $_endpointIds += $_ep.Id
            }
            $StaticGroup.EndpointIds = $_endpointIds

			Foreach($_property in $_propertyList) {
                If($StaticGroup[$_property] -ine $_old_group[$_property]) {
                    $_new_group += @{ $_property = $StaticGroup[$_property] }
                }
			}

            return Invoke-bConnectPatch -Controller "StaticGroups" -Version $_connectVersion -objectGuid $StaticGroup.Id -Data $_new_group
        } else {
            return $false
        }
    } else {
        return $false
    }
}

Export-ModuleMember Search-bConnectStaticGroup
Export-ModuleMember Get-bConnectStaticGroup
Export-ModuleMember New-bConnectStaticGroup
Export-ModuleMember Remove-bConnectStaticGroup
Export-ModuleMember Edit-bConnectStaticGroup
