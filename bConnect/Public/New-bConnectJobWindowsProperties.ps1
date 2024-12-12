Function New-bConnectJobWindowsProperties() {
    <#
        .Synopsis
            Creates a new WindowsProperties object for Jobs.
            Empty or filled with given information.
        .Parameter Priority
            The priority of the job
        .Parameter MaxConcurrentTargets
            Determines the max. count of clients which will execute the job concurrently.
        .Parameter Unlocksequence
            The sequence of characters required to enter for unlocking the endpoint’s input devices during job execution.
        .Parameter MinBandwidth
            The job will only be executed if the available bandwidth is greater than this.
        .Parameter CustomTrayInfo
            The cusom information shown to the user in the tray notifier.
        .Parameter CustomTrayInfoShutdown
            The custom information shown to the user when shutting down.
        .Parameter MandatoryTime
            The latest date when the job must be executed on the client. The user can not delay or deny the job if this date is exceeded.
        .Parameter MaxDelayMinutes
            The maximum time in minutes during which the user is able to delay the job.
        .Parameter RemindInterval
            The remind interval type. See RemindInterval for possible values.
        .Parameter UserActionType
            Determines if the user is allowed to deny/delay the job. See UserActionType for possible values.
        .Parameter KeyMouseLockType
            Determines if the input device’s should be locked during job execution. See KeyMouseLockType for possible values.
        .Parameter PrePostInstallType
            Determines if the job should add pre and/or post install steps. See PrePostInstallType for possible values.
        .Parameter JobStartType
            Determines the start type of the job. See JobStartType for possible values.
        .Parameter AtEndOfJobAction
            Determines the end of job action. See AtEndOfJobAction for possible values.
        .Parameter InfoWindowType
            Determines if the user is able to see the info window. See InfoWindowType for possible values.
        .Parameter AutoAssignment
            The auto assignment XML of the job.
        .Parameter Prerequisites
            The prerequisites XML of the job.
        .Parameter Options
            The job’s windows options.
        .Parameter Validity
            The time during which the job is valid (will be executed).
        .Parameter Interval
            The job interval.
        .Parameter RetryInterval
            The job’s retry interval.
        .Parameter Interval

        .Outputs
            WindowsProperties (see bConnect documentation for more details)
    #>

    [OutputType("System.Management.Automations.PSObject")]
    Param(
        [int]$Priority=500,
        [int]$MaxConcurrentTargets=30,
        [string]$Unlocksequence,
        [long]$MinBandwidth=100000000,
		[string]$CustomTrayInfo,
		[string]$CustomTrayInfoShutdown,
		[datetime]$MandatoryTime,
		[long]$MaxDelayMinutes=90,
		[ValidateSet("None","FiveMinutes","TenMinutes","FifteenMinutes","ThirtyMinutes","OneHour","TwoHours","FourHours","Degressive",ignoreCase=$true)][string]$RemindInterval,
		[ValidateSet("CanNotInfluence","CanDelay","CanDenyOrDelay","UserConsentRequired",ignoreCase=$true)][string]$UserActionType="CanNotInfluence",
		[ValidateSet("DetermineAutomatically","LockAccordingToSoftwareConfiguration","Lock","DoNotLock",ignoreCase=$true)][string]$KeyMouseLockType="DetermineAutomatically",
		[ValidateSet("ExecutePreAndPostInstallSteps","DoNotExecutePreAndPostInstallSteps","ExecuteOnlyPreInstallSteps","ExecuteOnlyPostInstallSteps",ignoreCase=$true)][string]$PrePostInstallType="ExecutePreAndPostInstallSteps",
		[ValidateSet("Active","Passive","ActiveWol","ActiveOnline","ActiveShutdown","ActiveShutdownAndOnline",ignoreCase=$true)][string]$JobStartType="ActiveOnline",
		[ValidateSet("NoAdditionalAction","ActivateScreenSaver","ShutdownSystem","ShutdownSystemIfStartedWithWoL","RestartSystem",ignoreCase=$true)][string]$AtEndOfJobAction="NoAdditionalAction",
		[ValidateSet("DetermineAutomatically","ShowAlways","ShowNever","ShowOnlyWhenBooting",ignoreCase=$true)][string]$InfoWindowType="DetermineAutomatically",
		[string]$AutoAssignment,
		[string]$Prerequisites,
        [PSCustomObject]$Options,
        [PSCustomObject]$Validity,
        [PSCustomObject]$Interval,
        [PSCustomObject]$RetryInterval
    )

    $_new_WindowsProperties = @{
		Priority             = $Priority;
        MaxConcurrentTargets = $MaxConcurrentTargets;
		MinBandwidth         = $MinBandwidth;
		MaxDelayMinutes      = $MaxDelayMinutes;
		UserActionType       = $UserActionType;
		KeyMouseLockType     = $KeyMouseLockType;
		PrePostInstallType   = $PrePostInstallType;
		JobStartType         = $JobStartType;
		AtEndOfJobAction     = $AtEndOfJobAction;
		InfoWindowType       = $InfoWindowType;
	}

<#     If(![int]::IsNullOrEmpty($Priority)) {
        $_new_WindowsProperties += @{ Priority = $Priority }
    }

    If(![int]::IsNullOrEmpty($MaxConcurrentTargets)) {
        $_new_WindowsProperties += @{ MaxConcurrentTargets = $MaxConcurrentTargets }
    } #>

    If(![string]::IsNullOrEmpty($Unlocksequence)) {
        $_new_WindowsProperties += @{ Unlocksequence = $Unlocksequence }
    }

<#     If(![long]::IsNullOrEmpty($MinBandwidth)) {
        $_new_WindowsProperties += @{ MinBandwidth = $MinBandwidth }
    } #>

    If(![string]::IsNullOrEmpty($CustomTrayInfo)) {
        $_new_WindowsProperties += @{ CustomTrayInfo = $CustomTrayInfo }
    }
	
    If(![string]::IsNullOrEmpty($CustomTrayInfoShutdown)) {
        $_new_WindowsProperties += @{ CustomTrayInfoShutdown = $CustomTrayInfoShutdown }
    }
	
    If($MandatoryTime) {
        $_new_WindowsProperties += @{ MandatoryTime = $MandatoryTime }
    }
			
<#     If(![long]::IsNullOrEmpty($MaxDelayMinutes)) {
        $_new_WindowsProperties += @{ MaxDelayMinutes = $MaxDelayMinutes }
    } #>
	
    If(![string]::IsNullOrEmpty($RemindInterval)) {
        $_new_WindowsProperties += @{ RemindInterval = $RemindInterval }
    }
	
<#     If(![string]::IsNullOrEmpty($UserActionType)) {
        $_new_WindowsProperties += @{ UserActionType = $UserActionType }
    } #>
	
<#     If(![string]::IsNullOrEmpty($KeyMouseLockType)) {
        $_new_WindowsProperties += @{ KeyMouseLockType = $KeyMouseLockType }
    } #>
	
<#     If(![string]::IsNullOrEmpty($PrePostInstallType)) {
        $_new_WindowsProperties += @{ PrePostInstallType = $PrePostInstallType }
    } #>
	
<#     If(![string]::IsNullOrEmpty($AtEndOfJobAction)) {
        $_new_WindowsProperties += @{ AtEndOfJobAction = $AtEndOfJobAction }
    } #>
	
<#     If(![string]::IsNullOrEmpty($InfoWindowType)) {
        $_new_WindowsProperties += @{ InfoWindowType = $InfoWindowType }
    } #>
	
    If(![string]::IsNullOrEmpty($AutoAssignment)) {
        $_new_WindowsProperties += @{ AutoAssignment = $AutoAssignment }
    }
	
    If(![string]::IsNullOrEmpty($Prerequisites)) {
        $_new_WindowsProperties += @{ Prerequisites = $Prerequisites }
    }
	
    If($Options) {
        $_new_WindowsProperties += @{ Options = $Options }
    }

    If($Validity) {
        $_new_WindowsProperties += @{ Validity = $Validity }
    }

    If($Interval) {
        $_new_WindowsProperties += @{ Interval = $Interval }
    }

    If($RetryInterval) {
        $_new_WindowsProperties += @{ RetryInterval = $RetryInterval }
    }

    return $_new_WindowsProperties
}
