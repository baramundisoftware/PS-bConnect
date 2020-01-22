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

    [OutputType("System.Management.Automations.PSObject")]
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
