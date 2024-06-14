Function New-bConnectJobIntervall() {
    <#
        .Synopsis
            Creates a new Intervall object for Jobs.
            Empty or filled with given information.
        .Parameter IntervalType
            The type of the interval.
        .Parameter Days
            The list of valid days when specifying IntervalType “Weekdays”. Must be empty otherwise.
        .Parameter Multiplicator
            The hour/day/minute multiplicator. Can only be used when specifying IntervalTypes ‘EveryXDays’, ‘EveryXHours’ or ‘EveryXMinutes’
        .Parameter StartTime
            The time the job will be started. Hour(from 0 – 23): Minute(from 0 - 59).
        .Parameter Repetitions
            The number of job repetitions.
        .Parameter RescheduleOnError
            The job will be rescheduled, even if the previous execution wasn’t successful.
        .Outputs
            JobIntervall object (see bConnect documentation for more details)
    #>

    [OutputType("System.Management.Automations.PSObject")]
    Param(
		[Parameter(Mandatory=$true)][ValidateSet("Weekdays","Every1stOfMonth","Every15thOfMonth","EveryXHours","EveryXDays","EveryXMinutes",ignoreCase=$true)][string]$IntervalType="Weekdays",
		[ValidateScript({
			# This parameter must only be used with IntervalType=Weekdays
			if($IntervalType -in "Weekdays"){
				$_.count -gt 0
			}
		})]
		[ValidateSet("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday",ignoreCase=$true)][string[]]$Days,
		[ValidateScript({
			# This parameter must only be used with IntervalType 'EveryXDays', 'EveryXHours' or 'EveryXMinutes'
			if($IntervalType -in "EveryXHours","EveryXDays","EveryXMinutes"){
				$_ -is [int]
			}
		})]
		[int]$Multiplicator,
		[Parameter(Mandatory=$true)][ValidateLength(5,5)][ValidatePattern("\d{2}[:]\d{2}")][string]$StartTime,
        [int]$Repetitions = -1,
        [bool]$RescheduleOnError = $true
    )
    $time_seprtr = ":"
    $StartTime_ary = $StartTime.Split($time_seprtr)
    $_new_StartTime = @{
        Hour   = [int]$StartTime_ary[0];
        Minute = [int]$StartTime_ary[1];
	}

    $_new_JobIntervall = @{
		StartTime = [PSCustomObject]$_new_StartTime;
		Repetitions = $Repetitions;
        RescheduleOnError = $RescheduleOnError;
	}

	if($IntervalType -in "EveryXHours","EveryXDays","EveryXMinutes"){
		$FinalDays = @('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')
	}
	elseif($IntervalType -in "Weekdays"){
		$FinalDays = $Days
	}
    If(![string]::IsNullOrEmpty($IntervalType)) {
        $_new_JobIntervall += @{ IntervalType = $IntervalType }
	}
    If($FinalDays) {
        $_new_JobIntervall += @{ Days = $FinalDays }
	}

    If($Multiplicator) {
        $_new_JobIntervall += @{ Multiplicator = $Multiplicator }
    }
	
    return $_new_JobIntervall
}
