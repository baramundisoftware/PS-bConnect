#--- Endpoint ---
Function Search-bConnectEndpoint() {
    <#
        .Synopsis
            Search for specified endpoints.
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
            Type = "endpoint";
            Term = $Term
        }

        return Invoke-bConnectGet -Controller "Search" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Get-bConnectEndpoint() {
    <#
        .Synopsis
            Get specified endpoint or all endpoints in given OrgUnit
        .Parameter EndpointGuid
            Valid GUID of a endpoint
        .Parameter OrgUnitGuid
            Valid GUID of a Orgunit
        .Parameter Username
            Valid Username
        .Parameter PublicKey
            If set, the result contains the associated public keys.
        .Parameter InstalledSoftware
            If set, the result contains the installed software.
        .Parameter SnmpData
            If set, the result contains the associated snmp data.
        .Outputs
            Array of Endpoint (see bConnect documentation for more details)
    #>

    Param (
        [string]$EndpointGuid,
        [string]$OrgUnitGuid,
        [string]$DynamicGroupGuid,
        [string]$StaticGroupGuid,
        [string]$Username,
        [switch]$PublicKey,
        [switch]$InstalledSoftware,
        [switch]$SnmpData
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{}
        If($EndpointGuid) {
            $_body = @{
                Id = $EndpointGuid
            }
        }

        If($OrgUnitGuid) {
            $_body = @{
                OrgUnit = $OrgUnitGuid
            }
        }

        If($DynamicGroupGuid) {
            $_body = @{
                DynamicGroup = $DynamicGroupGuid
            }
        }

        If($StaticGroupGuid) {
            $_body = @{
                StaticGroup = $StaticGroupGuid
            }
        }

        If($Username) {
            $_body = @{
                User = $Username
            }
        }

        If($PublicKey) {
            $_body += @{
                PubKey = $true
            }
        }

        If($InstalledSoftware) {
            $_body += @{
                InstalledSoftware = $true
            }
        }

        If($SnmpData) {
            $_body += @{
                SnmpData = $true
            }
        }

        return Invoke-bConnectGet -Controller "Endpoints" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

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

Function Remove-bConnectEndpoint() {
    <#
        .Synopsis
            Remove specified endpoint.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Parameter Endpoint
            Valid Endpoint object
        .Outputs
            Bool
    #>

    Param (
        [string]$EndpointGuid,
        [PSCustomObject]$Endpoint
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(![string]::IsNullOrEmpty($EndpointGuid)) {
            $_body = @{
                Id = $EndpointGuid
            }
        } elseif (![string]::IsNullOrEmpty($Endpoint.Id)) {
            $_body = @{
                Id = $Endpoint.Id
            }
        } else {
            return $false
        }

        return Invoke-bConnectDelete -Controller "Endpoints" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Edit-bConnectEndpoint() {
    <#
        .Synopsis
            Updates a existing endpoint.
        .Parameter Endpoint
            Valid modified endpoint
        .Outputs
            Endpoint (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][PSCustomObject]$Endpoint
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(Test-Guid $Endpoint.Id) {
            # We can not send the whole object because of not editable fields.
            # So we need to create a new one with editable fields only...
			# And as this might be too easy, we face another problem: we are only allowed to send the changed fields :(
			# Dirty workaround: reload the object and compare new vs. old
			$_old_endpoint = Get-bConnectEndpoint -EndpointGuid $Endpoint.Id
			$_old_endpoint = ConvertTo-Hashtable $_old_endpoint

			# common properties
            $_new_endpoint = @{ Id = $Endpoint.Id }
			$_propertyList = @(
                "DisplayName",
                "GuidOrgUnit"
            )
            $Endpoint = ConvertTo-Hashtable $Endpoint

            # Windows
			If($Endpoint.Type -eq [bConnectEndpointType]::WindowsEndpoint) {
                $_propertyList += @(
                    "HostName",
                    "Options",
                    "PrimaryMAC",
                    "Domain",
                    "GuidBootEnvironment",
                    "GuidHardwareProfile",
                    "PublicKey",
                    "Mode",
                    "ExtendedInternetMode"
                )
			}

            # BmsNet = Android, iOS, WP, OSX
			If(($Endpoint.Type -eq [bConnectEndpointType]::AndroidEndpoint) -or
				($Endpoint.Type -eq [bConnectEndpointType]::iOSEndpoint) -or
				($Endpoint.Type -eq [bConnectEndpointType]::WindowsPhoneEndpoint) -or
				($Endpoint.Type -eq [bConnectEndpointType]::MacEndpoint)) {
                $_propertyList += @(
                    "PrimaryUser",
                    "Owner",
                    "ComplianceCheckCategory"
                )
			}

			# OSX
			If($Endpoint.Type -eq [bConnectEndpointType]::MacEndpoint) {
                $_propertyList += @(
                    "HostName"
                )
            }

			Foreach($_property in $_propertyList) {
                If($Endpoint[$_property] -ine $_old_endpoint[$_property]) {
                    $_new_endpoint += @{ $_property = $Endpoint[$_property] }
                }
			}

            return Invoke-bConnectPatch -Controller "Endpoints" -Version $_connectVersion -objectGuid $Endpoint.Id -Data $_new_endpoint
        } else {
            return $false
        }
    } else {
        return $false
    }
}

Export-ModuleMember Search-bConnectEndpoint
Export-ModuleMember Get-bConnectEndpoint
Export-ModuleMember New-bConnectEndpoint
Export-ModuleMember Remove-bConnectEndpoint
Export-ModuleMember Edit-bConnectEndpoint
