Function New-bConnectJobValidity() {
    <#
        .Synopsis
            Creates a new JobValidity object for Jobs.
            Empty or filled with given information.
        .Parameter StartDate
            The job will be valid after StartDate.
        .Parameter EndDate
            The job is only valid before EndDate.
        .Parameter Days
            The list of days during which the job is valid.

        .Outputs
            JobValidity object (see bConnect documentation for more details)
    #>

    [OutputType("System.Management.Automations.PSObject")]
    Param(
		[datetime]$StartDate,
        [datetime]$EndDate,
        [PSCustomObject]$Days
    )

    $_new_JobValidity = @{}

    If(![datetime]::IsNullOrEmpty($StartDate)) {
        $_new_WindowsProperties += @{ StartDate = $StartDate }
    }

    If(![datetime]::IsNullOrEmpty($EndDate)) {
        $_new_WindowsProperties += @{ EndDate = $EndDate }
    }

    If($Days) {
        $_new_WindowsProperties += @{ Days = $Days }
    }

    return $_new_JobValidity
}
