Function New-bConnectApplication() {
    <#
        .Synopsis
            Create a new application.
        .Outputs
            NewApplication (see bConnect documentation for more details).
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    [OutputType("System.Management.Automations.PSObject","System.Boolean")]
    Param (
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][string]$Vendor,
        [Parameter(Mandatory=$true)][ValidateSet("NT4","Windows2000","WindowsXP","WindowsServer2003","WindowsVista","WindowsServer2008","Windows7","WindowsServer2008R2","WindowsXP_x64","WindowsServer2003_x64","WindowsVista_x64","WindowsServer2008_x64","Windows7_x64","WindowsServer2008R2_x64","Windows8","WindowsServer2012","Windows8_x64","WindowsServer2012_x64","Windows10","Windows10_x64","WindowsServer2016_x64","WindowsServer2019_x64",ignoreCase=$true)][string[]]$ValidForOS,
        [string]$Comment,
        [string]$ParentId = "EAD9DFC5-1937-484A-8FCC-0977AA79F963", #guid of "Applications" as fallback
        [string]$Version,
        [string]$Category,
        [PSCustomObject]$InstallationData,
        [PSCustomObject]$UninstallationData,
        [string]$ConsistencyChecks,
        [PSCustomObject[]]$Files,
        [PSCustomObject[]]$SoftwareDependencies,
        [float]$Cost = 0,
        [ValidateSet("AnyUser","InstallUser","LocalInstallUser","LocalSystem","LoggedOnUser","RegisteredUser","SpecifiedUser",ignoreCase=$true)][string]$SecurityContext,
        [PSCustomObject[]]$Licenses,
        [PSCustomObject[]]$AUT
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Name = $Name;
            Vendor = $Vendor;
            ValidForOS = $ValidForOS;
            Cost = $Cost
        }

		If(![string]::IsNullOrEmpty($Comment)) {
			$_body += @{ Comment = $Comment }
		}

		If(![string]::IsNullOrEmpty($ParentId)) {
			$_body += @{ ParentId = $ParentId }
		}

		If(![string]::IsNullOrEmpty($Version)) {
			$_body += @{ Version = $Version }
		}

		If(![string]::IsNullOrEmpty($Category)) {
			$_body += @{ Category = $Category }
		}

		If($InstallationData) {
			$_body += @{ Installation = $InstallationData }
		}

		If($Files) {
			$_body += @{ Files = $Files }
		}

		If($SoftwareDependencies) {
			$_body += @{ SoftwareDependencies = $SoftwareDependencies }
		}

        If($UninstallationData) {
            $_body += @{ Uninstallation = $UninstallationData }
        }

		If(![string]::IsNullOrEmpty($ConsistencyChecks)) {
			$_body += @{ ConsistencyChecks = $ConsistencyChecks }
		}

		If(![string]::IsNullOrEmpty($SecurityContext)) {
			$_body += @{ SecurityContext = $SecurityContext }
		}

        If($Licenses.Count -gt 0) {
            $_body += @{ Licenses = $Licenses }
        }

        If($AUT.Count -gt 0) {
            $_body += @{ EnableAUT = $true; AUT = $AUT }
        }

        if($PSCmdlet.ShouldProcess($_body.Name, "Create new application.")){
            return Invoke-bConnectPost -Controller "Applications" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
