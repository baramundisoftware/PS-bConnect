Function Edit-bConnectJobWindowsOptions() {

    <#
        .Synopsis
            Creates a new WindowsOptions object for Jobs.
            Empty or filled with given information.
        .Parameter JobWindowsOptions
            A valid JobWindowsOptions object.
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
        [Parameter(Mandatory=$true)][PSCustomObject]$JobWindowsOptions,
        [bool]$LatestLogOff,
        [bool]$LatestLogon,
        [bool]$LogoffUserBeforeJobStart,
        [bool]$UserDelayShutdown,
        [bool]$UseForceLogoff,
        [bool]$UsersettingsPerUser,
        [bool]$WillReinstall,
        [bool]$IgnoreBandwidth,
        [bool]$IgnoreBITS,
        [bool]$SupportEndpointsInInternetMode
    )

    $_new_JobWindowsOptions = ConvertTo-Hashtable $JobWindowsOptions

    # We remove the input object from the argument hash table.
    # Because we want to iterate through it later.
    $TrashResult = $PSBoundParameters.Remove('JobWindowsOptions')

    Foreach($_property in $PsBoundParameters.GetEnumerator()) {
        # Write-Output ("Key={0} Value={1}" -f $_property.Key,$_property.Value)
        if($_new_JobWindowsOptions.($_property.Key)){
            $_new_JobWindowsOptions.($_property.Key) = $_property.Value
        }else{
            $_new_JobWindowsOptions.Add($_property.Key,$_property.Value)
        }

	}
    #Write-Output $_new_JobWindowsOptions
    return $_new_JobWindowsOptions
}