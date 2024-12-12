Function New-bConnectJobValidityDay() {
    <#
        .Synopsis
            Creates a new JobValidityDay object for Jobs.
            Empty or filled with given information.
        .Parameter DayType
            TThe type of the day. See DayType for possible values.
        .Parameter Timeboxes
            The list of timeboxes during which the job is valid.

        .Outputs
            JobValidityDay object (see bConnect documentation for more details)
    #>

    [OutputType("System.Management.Automations.PSObject")]
    Param(
		[ValidateSet("EveryDay","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","WeekDay","WeekendDay",ignoreCase=$true)][string]$DayType,
        [PSCustomObject]$Timeboxes
    )

    $_new_JobValidityDay = @{}

    If(![string]::IsNullOrEmpty($DayType)) {
        $_new_WindowsProperties += @{ DayType = $DayType }
	}
    If($Timeboxes) {
        $_new_WindowsProperties += @{ Timeboxes = $Timeboxes }
    }

    return $_new_JobValidityDay
}
