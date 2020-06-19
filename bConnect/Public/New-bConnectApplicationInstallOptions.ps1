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

    [OutputType("System.Management.Automations.PSObject")]
    Param(
        [ValidateSet("NoReboot","Reboot","AppReboot","DeferrableReboot",ignoreCase=$true)][string]$RebootBehaviour = "NoReboot",
        [bool]$AllowReinstall = $true,
        [bool]$UsebBT,
        [ValidateSet("Silent","NeedsDesktop","VisibleWhenUserLoggedOn",ignoreCase=$true)][string]$VisibleExecution = "Silent",
        [bool]$CopyLocally,
        [bool]$DisableInputDevices,
        [bool]$DontSetAsInstalled,
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
