Function New-bConnectStaticGroup() {
    <#
        .Synopsis
            Create a new StaticGroup.
        .Parameter Name
            Name of the StaticGroup.
        .Parameter ParentGuid
            Valid GUID of the parent OrgUnit in hierarchy (default: "Static Groups").
        .Parameter Endpoints
            Array of Endpoints or single Endpoint.
        .Parameter Comment
            Comment for the StaticGroup.
        .Outputs
            StaticGroup (see bConnect documentation for more details).
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    [OutputType("System.Management.Automations.PSObject","System.Boolean")]
    Param (
        [Parameter(Mandatory=$true)][string]$Name,
        [string]$ParentGuid = "5020494B-04D3-4654-A256-80731E953746", #guid of "Static Groups" as fallback
        [PSCustomObject[]]$Endpoints,
		[string]$Comment
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Name = $Name;
            ParentId = $ParentGuid;
        }

        If(![string]::IsNullOrEmpty($Endpoints)) {
            $_endpointIds = @()
            Foreach($_ep in $Endpoints) {
                $_endpointIds += $_ep.Id
            }
            $_body += @{
                EndpointIds  = $_endpointIds
            }
        #if $Endpoints is just a single EP Object instead of an Array of EPs
        }elseif ((($Endpoints -is [array])-and $Endpoints.Count -gt 0)) {
            $_endpointIds = @($Endpoints.Id)
            $_body += @{
                EndpointIds  = $_endpointIds
            }
        }

		If(![string]::IsNullOrEmpty($Comment)) {
			$_body += @{ Comment = $Comment }
		}

        if($PSCmdlet.ShouldProcess($_body.Name, "Create new static group.")){
            return Invoke-bConnectPost -Controller "StaticGroups" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
