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
                $_endpointIds += $_ep
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
