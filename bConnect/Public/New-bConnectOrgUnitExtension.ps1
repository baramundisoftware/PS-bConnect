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

    [CmdletBinding()]
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
