#--- Org Unit ---
Function Search-bConnectOrgUnit() {
    <#
        .Synopsis
            Search for specified OrgUnit.
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
            Type = "orgunit";
            Term = $Term
        }

        return Invoke-bConnectGet -Controller "Search" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function New-bConnectOrgUnitExtension() {
    <#
        .Synopsis
            Creates a new Extension for OrgUnits.
            Empty or filled with given information.
        .Parameter DIP
            Valid DIP or list of DIPs (separated by ";").
        .Parameter Domain
            Valid Windows Domain Name.
        .Parameter LocalAdminPassword
            Local admin password for OU (set during OS-Install)
            Must be encrypted with baramundi Cryptor
        .Parameter EnableDHCP
        .Parameter SubnetMask
        .Parameter DefaultGateway
        .Parameter DnsServer
        .Parameter DnsServer2
        .Parameter DnsDomain
        .Parameter WinsServer
        .Parameter WinsServer2
        .Parameter AutoInstallJobs
            Array of valid Job-GUIDs
        .Parameter HardwareProfiles
            Array of valid HardwareProfile-GUIDs
        .Parameter InheritAutoInstallJobs
            Array of valid inherited Job-GUIDs
        .Parameter RequestableJobs
            Array of valid Job-GUIDs
        .Outputs
            Array of OrgUnit extension (see bConnect documentation for more details)
    #>

    Param(
        [string]$DIP = "",
        [string]$Domain = "",
        [SecureString]$LocalAdminPassword = "",
        [switch]$EnableDHCP = $true,
        [string]$SubnetMask = "",
        [string]$DefaultGateway = "",
        [string]$DnsServer = "",
        [string]$DnsServer2 = "",
        [string]$DnsDomain = "",
        [string]$WinsServer = "",
        [string]$WinsServer2 = "",
        [string[]]$AutoInstallJobs = @(),
        [string[]]$HardwareProfiles = @(),
        [switch]$InheritAutoInstallJobs = $true,
        [string[]]$RequestableJobs = @()
    )

    If($EnableDHCP) {
        $_enabledhcp = $true
    } else {
        $_enabledhcp = $false
    }

    If($InheritAutoInstallJobs) {
        $_inheritAutoInstallJobs = $true
    } else {
        $_inheritAutoInstallJobs = $false
    }

    $_autoInstallJobs = @()
    Foreach($aiJob in $AutoInstallJobs) {
        If(Test-Guid -Guid $aiJob) {
            $_autoInstallJobs += $aiJob
        } else {
            $_job = Search-bConnectJob -Term $aiJob
            $_autoInstallJobs += $_job.Id
        }
    }

    $_requestableJobs = @()
    Foreach($rJob in $RequestableJobs) {
        If(Test-Guid -Guid $rJob) {
            $_requestableJobs += $rJob
        } else {
            $_job = Search-bConnectJob -Term $rJob
            $_requestableJobs += $_job.Id
        }
    }

    $_new_extension = @{
        DIP = $DIP;
        Domain = $Domain;
        LocalAdminPassword = $LocalAdminPassword;
        EnableDHCP = $_enabledhcp;
        SubnetMask = $SubnetMask;
        DefaultGateway = $DefaultGateway;
        DnsServer = $DnsServer;
        DnsServer2 = $DnsServer2;
        DnsDomain = $DnsDomain;
        WinsServer = $WinsServer;
        WinsServer2 = $WinsServer2;
        AutoInstallJobs = $_autoInstallJobs;
        HardwareProfiles = $HardwareProfiles;
        InheritAutoInstallJobs = $_inheritAutoInstallJobs;
        RequestableJobs = $_requestableJobs;
    }

    return $_new_extension
}

Function Get-bConnectOrgUnit() {
    <#
        .Synopsis
            Get specified OrgUnit.
        .Parameter OrgUnit
            Name (wildcards supported) or GUID of the OrgUnit.
        .Parameter SubGroups
            List subgroups of given OrgUnit.
            Only used if parameter "name" is a valid GUID.
        .Outputs
            Array of OrgUnit (see bConnect documentation for more details)
    #>

    Param(
        [Parameter(Mandatory=$true)][string]$OrgUnit,
        [switch]$SubGroups
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(Test-Guid $OrgUnit) {
            If($SubGroups) {
                $_body = @{
                    OrgUnit = $OrgUnit
                }
            } else {
                $_body = @{
                    Id = $OrgUnit
                }
            }

            return Invoke-bConnectGet -Controller "OrgUnits" -Data $_body -Version $_connectVersion
        } else {
			# fetching orgunits with name is not supported; therefore we need a workaround for getting the specified orgunit...
			$_bmsVersion = Get-bConnectInfo
            If($_bmsVersion.bMSVersion -imatch "16.*") {
				# Search available since bMS 2016R1
				$_groups = Search-bConnectOrgUnit -Term $OrgUnit

				return $_groups
			} else {
	           	# no search, so keep looping ;)
            	$_groups = Invoke-bConnectGet -Controller "OrgUnits" -Version $_connectVersion
	            $_ret = @()
    	        Foreach($_group in $_groups) {
        	        If($_group.Name -match $orgUnit) {
            	        $_ret += $_group
                	}
	            }

    	        return $_ret
	        }
		}
    } else {
        return $false
    }
}

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

Function Remove-bConnectOrgUnit() {
    <#
        .Synopsis
            Remove specified OrgUnit.
        .Parameter OrgUnitGuid
            Valid GUID of a OrgUnit.
        .Outputs
            Bool
    #>

    Param (
        [Parameter(Mandatory=$true)][string]$OrgUnitGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            Id = $OrgUnitGuid
        }

        return Invoke-bConnectDelete -Controller "OrgUnits" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Edit-bConnectOrgUnit() {
    <#
        .Synopsis
            Updates a existing OrgUnit.
        .Parameter OrgUnit
            Valid modified OrgUnit
        .Outputs
            OrgUnit (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][PSCustomObject]$OrgUnit
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(Test-Guid $OrgUnit.Id) {
            $_orgUnit = ConvertTo-Hashtable $OrgUnit
            return Invoke-bConnectPatch -Controller "OrgUnits" -Version $_connectVersion -objectGuid $OrgUnit.Id -Data $_orgUnit
        } else {
            return $false
        }
    } else {
        return $false
    }
}

Export-ModuleMember Search-bConnectOrgUnit
Export-ModuleMember New-bConnectOrgUnitExtension
Export-ModuleMember Get-bConnectOrgUnit
Export-ModuleMember New-bConnectOrgUnit
Export-ModuleMember Remove-bConnectOrgUnit
Export-ModuleMember Edit-bConnectOrgUnit
