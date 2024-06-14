Function New-bConnectJobWindowsOptions() {
    <#
        .Synopsis
            Creates a new WindowsOptions object for Jobs.
            Empty or filled with given information.
        .Parameter LatestLogOff
            If true the user will be logged off as late as possible.
        .Parameter LatestLogon
            If true the user will be logged on as late as possible.
        .Parameter LogoffUserBeforeJobStart
            If true the user will be logged off before job start.
        .Parameter UserDelayShutdown
            If true the user is able to delay shutdowns.
        .Parameter UseForceLogoff
            If true the user will be logged off even if there are unsaved changes.
        .Parameter UsersettingsPerUser
            If true, the user settings will be executed per user during software deployment.
        .Parameter WillReinstall
            If true, the job will reinstall the client.
        .Parameter IgnoreBandwidth
            If true, the job will be executed ignoring the configured MinBandwidth.
        .Parameter IgnoreBITS
            If true, the job will not support baramundi background transfer.
        .Parameter SupportEndpointsInInternetMode
            If true, the job will also be executed on clients which are currently roaming.
        .Outputs
            WindowsOptions object (see bConnect documentation for more details)
    #>

    [OutputType("System.Management.Automations.PSObject")]
    Param(
        [bool]$LatestLogOff,
        [bool]$LatestLogon,
        [bool]$LogoffUserBeforeJobStart,
        [bool]$UserDelayShutdown,
        [bool]$UseForceLogoff,
        [bool]$UsersettingsPerUser,
        [bool]$WillReinstall,
        [bool]$IgnoreBandwidth = $true,
        [bool]$IgnoreBITS,
        [bool]$SupportEndpointsInInternetMode
    )

    $_new_WindowsJobOptions = @{
        LatestLogOff = $LatestLogOff;
        LatestLogon = $LatestLogon;
        LogoffUserBeforeJobStart = $LogoffUserBeforeJobStart;
        UserDelayShutdown = $UserDelayShutdown;
        UseForceLogoff = $UseForceLogoff;
        UsersettingsPerUser = $UsersettingsPerUser;
        WillReinstall = $WillReinstall;
        IgnoreBandwidth = $IgnoreBandwidth;
        IgnoreBITS = $IgnoreBITS;
		SupportEndpointsInInternetMode = $SupportEndpointsInInternetMode;
    }

    return $_new_WindowsJobOptions
}
