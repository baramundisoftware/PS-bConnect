#--- Applications ---
Function Search-bConnectApplication() {
    <#
        .Synopsis
            Search for specified applications and apps.
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
            Type = "software";
            Term = $Term
        }

        return Invoke-bConnectGet -Controller "Search" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function New-bConnectApplicationInstallationData() {
    <#
        .Synopsis
            Creates a new InstallationData for Applications.
            Empty or filled with given information.
        .Parameter Command
            Installation command
        .Parameter Parameter
            Parameter for installation command
        .Parameter ResponseFile
            ResponseFile for the installation
        .Parameter EngineFile
            File for installation engine (Engine will be set automatically based on EngineFile; only bDS supported in this PS module)
        .Parameter Options
            InstallApplicationOption object
        .Parameter UserSettings
            InstallUserSettings object
        .Outputs
            InstallationData (see bConnect documentation for more details)
    #>

    Param(
        [string]$Command,
        [string]$Parameter,
        [string]$ResponseFile,
        [string]$EngineFile,
        [PSCustomObject]$Options,
        [PSCustomObject]$UserSettings
    )

    $_new_installationData = @{}

    If(![string]::IsNullOrEmpty($Command)) {
        $_new_installationData += @{ Command = $Command }
    }

    If(![string]::IsNullOrEmpty($Parameter)) {
        $_new_installationData += @{ Parameter = $Parameter }
    }

    If(![string]::IsNullOrEmpty($ResponseFile)) {
        $_new_installationData += @{ ResponseFile = $ResponseFile }
    }

    If(![string]::IsNullOrEmpty($EngineFile)) {
        $_new_installationData += @{ Engine = "baramundi Deploy Script"; EngineFile = $EngineFile }
    }

    If($Options) {
        $_new_installationData += @{ Options = $Options }
    }

    If($UserSettings) {
        $_new_installationData += @{ UserSettings = $UserSettings }
    }

    return $_new_installationData
}

Function New-bConnectApplicationInstallOptions() {
    <#
        .Synopsis
            Creates a new InstallApplicationOption for Applications.
            Empty or filled with given information.
        .Parameter RebootBehaviour
            Reboot behaviour after installation
        .Parameter AllowReinstall
            If set, reinstallation is allowed
        .Parameter UseBbt
            If set, bBT is supported
        .Parameter VisibleExecution
            Shows in which cases the execution of this software is visible
        .Parameter CopyLocally
            If set, installation files should be copied to local filesystem
        .Parameter DisableInputDevices
            If set, no input devices will be available during installation
        .Parameter DontSetAsInstalled
            If set, this application shouldn’t be shown as installed, after installation
        .Parameter Target
            Target path variable
        .Outputs
            InstallApplicationOption (see bConnect documentation for more details)
    #>

    Param(
        [ValidateSet("NoReboot","Reboot","AppReboot","DeferrableReboot",ignoreCase=$true)][string]$RebootBehaviour = "NoReboot",
        [switch]$AllowReinstall = $true,
        [switch]$UsebBT,
        [ValidateSet("Silent","NeedsDesktop","VisibleWhenUserLoggedOn",ignoreCase=$true)][string]$VisibleExecution = "Silent",
        [switch]$CopyLocally,
        [switch]$DisableInputDevices,
        [switch]$DontSetAsInstalled,
        [string]$Target
    )

    $_new_installationOption = @{
        RebootBehaviour = $RebootBehaviour;
        AllowReinstall = $AllowReinstall;
        UsebBT = $UsebBT;
        VisibleExecution = $VisibleExecution;
        CopyLocally = $CopyLocally;
        DisableInputDevices = $DisableInputDevices;
        DontSetAsInstalled = $DontSetAsInstalled;
        MapShare = $false;
        Target = $Target;
    }

    return $_new_installationOption
}

Function New-bConnectApplicationUninstallOptions() {
    <#
        .Synopsis
            Creates a new UninstallApplicationOption for Applications.
            Empty or filled with given information.
        .Parameter RebootBehaviour
            Reboot behaviour after installation
        .Parameter RemoveUnknownSoftware
            If set, removal of not installed software will be started
        .Parameter UseBbt
            If set, bBT is supported
        .Parameter VisibleExecution
            Shows in which cases the execution of this software is visible
        .Parameter CopyLocally
            If set, installation files should be copied to local filesystem
        .Parameter DisableInputDevices
            If set, no input devices will be available during installation
        .Outputs
            InstallApplicationOption (see bConnect documentation for more details)
    #>

    Param(
        [ValidateSet("NoReboot","Reboot","AppReboot","DeferrableReboot",ignoreCase=$true)][string]$RebootBehaviour = "NoReboot",
        [switch]$RemoveUnknownSoftware,
        [switch]$UsebBT,
        [ValidateSet("Silent","NeedsDesktop","VisibleWhenUserLoggedOn",ignoreCase=$true)][string]$VisibleExecution = "Silent",
        [switch]$CopyLocally,
        [switch]$DisableInputDevices
    )

    $_new_uninstallationOption = @{
        RebootBehaviour = $RebootBehaviour;
        RemoveUnknownSoftware = $RemoveUnknownSoftware;
        UsebBT = $UsebBT;
        VisibleExecution = $VisibleExecution;
        CopyLocally = $CopyLocally;
        DisableInputDevices = $DisableInputDevices;
    }

    return $_new_uninstallationOption
}

Function New-bConnectApplicationFile() {
    <#
        .Synopsis
            Creates a new ApplicationFile for Applications.
        .Parameter Source
            Path or file
        .Parameter Type
            Type of the source
        .Outputs
            ApplicationFile (see bConnect documentation for more details)
    #>

    Param(
        [Parameter(Mandatory=$true)][string]$Source,
        [Parameter(Mandatory=$true)][ValidateSet("FolderWithSubFolders","SingleFolder","File",ignoreCase=$true)][string]$Type
    )

    $_new_applicationFile = @{
        Source = $Source;
        Type = $Type;
    }

    return $_new_applicationFile
}

Function New-bConnectApplicationLicense() {
    <#
        .Synopsis
            Creates a new ApplicationLicense for Applications.
        .Parameter Count
            License count
        .Parameter LicenseKey
            License key
        .Parameter Offline
            Amount of offline licenses
        .Outputs
            ApplicationLicense (see bConnect documentation for more details)
    #>

    Param(
        [Parameter(Mandatory=$true)][string]$LicenseKey,
        [int]$Count = 0,
        [int]$Offline = 0
    )

    $_new_applicationLicense = @{
        Count = $Count;
        LicenseKey = $LicenseKey;
        Offline = $Offline;
    }

    return $_new_applicationLicense
}

Function New-bConnectApplicationInstallUserSettings() {
    <#
        .Synopsis
            Creates a new InstallUserSettings for Applications.
        .Parameter baramundiDeployScript
            Path to the deploy script that needs to be executed during installation
        .Parameter ValidForInstallUser
            If set, script will also run for the install user
        .Parameter RunbDSVisible
            If set, bDS will run visible
        .Parameter CopyScriptToClient
            If set, script will be copied to client
        .Parameter ExecuteAtEveryLogin
            If set, script will run on every login
        .Outputs
            InstallUserSettings (see bConnect documentation for more details)
    #>

    Param(
        [string]$baramundiDeployScript,
        [switch]$ValidForInstallUser,
        [switch]$RunbDSVisible,
        [switch]$CopyScriptToClient,
        [switch]$ExecuteAtEveryLogin
    )

    $_new_installUserSettings = @{
        baramundiDeployScript = $baramundiDeployScript;
        ValidForInstallUser = $ValidForInstallUser;
        RunbDSVisible = $RunbDSVisible;
        CopyScriptToClient = $CopyScriptToClient;
        ExecuteAtEveryLogin = $ExecuteAtEveryLogin;
    }

    return $_new_installUserSettings
}

Function New-bConnectApplicationUninstallUserSettings() {
    <#
        .Synopsis
            Creates a new UninstallUserSettings for Applications.
        .Parameter baramundiDeployScript
            Path to the deploy script that needs to be executed during uninstallation
        .Parameter ValidForInstallUser
            If set, script will also run for the install user
        .Parameter RunbDSVisible
            If set, bDS will run visible
        .Parameter CopyScriptToClient
            If set, script will be copied to client
        .Outputs
            UninstallUserSettings (see bConnect documentation for more details)
    #>

    Param(
        [string]$baramundiDeployScript,
        [switch]$ValidForInstallUser,
        [switch]$RunbDSVisible,
        [switch]$CopyScriptToClient
    )

    $_new_uninstallUserSettings = @{
        baramundiDeployScript = $baramundiDeployScript;
        ValidForInstallUser = $ValidForInstallUser;
        RunbDSVisible = $RunbDSVisible;
        CopyScriptToClient = $CopyScriptToClient;
    }


    return $_new_uninstallUserSettings
}

Function New-bConnectApplicationAUTFileRule() {
    <#
        .Synopsis
            Creates a new AUTFileRule for Applications.
        .Parameter FileName
            Name of the file
        .Parameter FileSize
            Size of the file
        .Parameter Date
            Timestamp as Date of the file
        .Parameter CRC
            Checksum of the file
        .Parameter Version
            Version of the file
        .Parameter Company
            Company of the file
        .Parameter ProductName
            Product name of the file
        .Parameter InternalName
            Internal name of the file
        .Parameter Language
            Language of the file
        .Parameter ProductVersion
            Product version of the file
        .Parameter FileDescription
            File description of the file
        .Parameter FileVersionNumeric
            Numerical file version
        .Parameter CommandLine
            Command line parameters
        .Outputs
            AUTFileRule (see bConnect documentation for more details)
    #>

    Param(
        [string]$FileName,
        [uint64]$FileSize,
        [string]$Date,
        [uint64]$CRC,
        [string]$Version,
        [string]$Company,
        [string]$ProductName,
        [string]$InternalName,
        [string]$Language,
        [string]$ProductVersion,
        [string]$FileDescription,
        [string]$FileVersionNumeric,
        [string]$CommandLine
    )

    $_new_aut = @{
        FileName = $FileName;
        FileSize = $FileSize;
        Date = $Date;
        CRC = $CRC;
        Version = $Version;
        Company = $Company;
        ProductName = $ProductName;
        InternalName = $InternalName;
        Language = $Language;
        ProductVersion = $ProductVersion;
        FileDescription = $FileDescription;
        FileVersionNumeric = $FileVersionNumeric;
        CommandLine = $CommandLine;
    }

    return $_new_aut
}

Function New-bConnectApplication() {
    <#
        .Synopsis
            Create a new application.
        .Outputs
            NewEndpoint (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][string]$Vendor,
        [Parameter(Mandatory=$true)][ValidateSet("NT4","Windows2000","WindowsXP","WindowsServer2003","WindowsVista","WindowsServer2008","Windows7","WindowsServer2008R2","WindowsXP_x64","WindowsServer2003_x64","WindowsVista_x64","WindowsServer2008_x64","Windows7_x64","WindowsServer2008R2_x64","Windows8","WindowsServer2012","Windows8_x64","WindowsServer2012_x64","Windows10","Windows10_x64","WindowsServer2016_x64",ignoreCase=$true)][string[]]$ValidForOS,
        [string]$Comment,
        [string]$ParentGuid, # = "C1A25EC3-4207-4538-B372-8D250C5D7908", #guid of "Logical Group" as fallback
        [string]$Version,
        [string]$Category,
        [PSCustomObject]$InstallationData,
        [PSCustomObject]$UninstallationData,
        [string]$ConsistencyChecks,
        [PSCustomObject[]]$ApplicationFile,
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

		If(![string]::IsNullOrEmpty($ParentGuid)) {
			$_body += @{ ParentGuid = $ParentGuid }
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

        return Invoke-bConnectPost -Controller "Applications" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Get-bConnectApplication() {
    <#
        .Synopsis
            Get specified application, all applications in given OrgUnit or all applications on an specific endpoint.
        .Parameter ApplicationGuid
            Valid GUID of a application.
        .Parameter OrgUnitGuid
            Valid GUID of a Orgunit.
        .Parameter EndpointGuid
            Valid GUID of an endpoint.
        .Outputs
            Array of Application (see bConnect documentation for more details).
    #>

    Param (
        [string]$ApplicationGuid,
        [string]$OrgUnitGuid,
        [string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($EndpointGuid) {
            $_body = @{
                EndpointId = $EndpointGuid
            }
        }

        If($OrgUnitGuid) {
            $_body = @{
                OrgUnit = $OrgUnitGuid
            }
        }

        If($ApplicationGuid) {
            $_body = @{
                Id = $ApplicationGuid
            }
        }

        return Invoke-bConnectGet -Controller "Applications" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Remove-bConnectApplication() {
    <#
        .Synopsis
            Remove specified application.
        .Parameter ApplicationGuid
            Valid GUID of a application.
        .Parameter Application
            Valid Application object
        .Outputs
            Bool
    #>

    Param (
        [string]$ApplicationGuid,
        [PSCustomObject]$Application
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(![string]::IsNullOrEmpty($ApplicationGuid)) {
            $_body = @{
                Id = $ApplicationGuid
            }
        } elseif (![string]::IsNullOrEmpty($Application.Id)) {
            $_body = @{
                Id = $Application.Id
            }
        } else {
            return $false
        }

        return Invoke-bConnectDelete -Controller "Applications" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}

Function Edit-bConnectApplication() {
    <#
        .Synopsis
            Create a new application.
        .Parameter Application
            Application object (hashtable).
        .Outputs
            NewEndpoint (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][PSCustomObject]$Application
    )

    If($Application.AUT.Count -gt 0) {
        $Application.EnableAUT = $true
    }


    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_Application = ConvertTo-Hashtable $Application
        return Invoke-bConnectPatch -Controller "Applications" -Version $_connectVersion -objectGuid $_Application.Id -Data $_Application
    } else {
        return $false
    }
}

Export-ModuleMember Search-bConnectApplication
Export-ModuleMember Get-bConnectApplication
Export-ModuleMember New-bConnectApplication
Export-ModuleMember New-bConnectApplicationInstallOptions
Export-ModuleMember New-bConnectApplicationInstallUserSettings
Export-ModuleMember New-bConnectApplicationInstallationData
Export-ModuleMember New-bConnectApplicationUninstallOptions
Export-ModuleMember New-bConnectApplicationUninstallUserSettings
Export-ModuleMember New-bConnectApplicationUninstallationData
Export-ModuleMember New-bConnectApplicationAUTFileRule
Export-ModuleMember New-bConnectApplicationLicense
Export-ModuleMember Remove-bConnectApplication
Export-ModuleMember Edit-bConnectApplication
