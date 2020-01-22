Function New-bConnectEndpoint() {
    <#
        .Synopsis
            Create a new endpoint.
        .Parameter Type
            enum bConnectEndpointType.
        .Parameter DisplayName
            DisplayName of the new endpoint. This is also used as hostname for Windows-Endpoints.
        .Parameter GroupGuid
            Valid GUID of the target OU (default: "Logical Group").
        .Parameter PrimaryUser
            Primary user of this endpoint. Mandatory for WindowsPhone-Endpoints.
        .Outputs
            NewEndpoint (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][bConnectEndpointType]$Type,
        [Parameter(Mandatory=$true)][string]$DisplayName,
        [string]$GroupGuid = "C1A25EC3-4207-4538-B372-8D250C5D7908", #guid of "Logical Group" as fallback
		[string]$PrimaryMac,
		[string]$HostName,
		[string]$Domain,
		[string]$Options,
		[string]$GuidBootEnvironment,
		[string]$GuidHardwareProfile,
        [string]$PrimaryUser = "",
        [ValidateSet("LAN","Internet","Dynamic")][string]$Mode,
        [switch]$ExtendedInternetMode
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Type = $type;
            DisplayName = $displayname;
            GuidGroup = $groupGuid;
            PrimaryUser = $primaryUser
        }

		If($Type -eq [bConnectEndpointType]::WindowsEndpoint) {
			If(![string]::IsNullOrEmpty($PrimaryMac)) {
				$_body += @{ PrimaryMac = $PrimaryMac }
			}

			If(![string]::IsNullOrEmpty($HostName)) {
				$_body += @{ HostName = $HostName }
			}

			If(![string]::IsNullOrEmpty($Domain)) {
				$_body += @{ Domain = $Domain }
			}

			If(![string]::IsNullOrEmpty($Options)) {
				$_body += @{ Options = $Options }
			}

			If(![string]::IsNullOrEmpty($GuidBootEnvironment)) {
				$_body += @{ GuidBootEnvironment = $GuidBootEnvironment }
			}

			If(![string]::IsNullOrEmpty($GuidHardwareProfile)) {
				$_body += @{ GuidHardwareProfile = $GuidHardwareProfile }
            }

			If($Mode) {
				$_body += @{ Mode = $Mode }
            }

			If($ExtendedInternetMode) {
				$_body += @{ ExtendedInternetMode = $ExtendedInternetMode }
			}
		}

        return Invoke-bConnectPost -Controller "Endpoints" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
