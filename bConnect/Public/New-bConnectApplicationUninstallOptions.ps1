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
