Function New-bConnectOrgUnit() {
    <#
        .Synopsis
            Create a new OrgUnit.
        .Parameter Name
            Name of the OrgUnit.
        .Parameter ParentGuid
            Valid GUID of the parent OrgUnit in hierarchy (default: "Logical Group").
        .Parameter Comment
            Comment for the OrgUnit.
        .Parameter Extension
            Hashtable Extension (see bConnect documentation for more details).
        .Outputs
            NewOrgUnit (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][string]$Name,
        [string]$ParentGuid = "C1A25EC3-4207-4538-B372-8D250C5D7908", #guid of "Logical Group" as fallback
		[string]$Comment,
        [PSCustomObject]$Extension
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Name = $Name;
            ParentId = $ParentGuid;
        }

		If(![string]::IsNullOrEmpty($Comment)) {
			$_body += @{ Comment = $Comment }
		}

        If($Extension) {
            $_body += @{ Extension = $Extension }
        }

        return Invoke-bConnectPost -Controller "OrgUnits" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
