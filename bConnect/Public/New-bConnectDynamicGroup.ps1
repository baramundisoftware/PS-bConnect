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

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    [OutputType("System.Management.Automations.PSObject","System.Boolean")]
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

        if($PSCmdlet.ShouldProcess($_body.Name, "Create new dynamic group.")){
            return Invoke-bConnectPost -Controller "DynamicGroups" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
