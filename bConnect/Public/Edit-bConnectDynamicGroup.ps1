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
