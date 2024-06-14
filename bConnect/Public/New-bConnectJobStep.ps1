Function New-bConnectJobStep() {
    <#
        .Synopsis
            Creates a new list with a Windows job step for Applications.
        .Parameter ApplicationGuid
            Valid GUID of a application.
        .Parameter Sequence
            Set the sequence of the job step.
        .Parameter JobStepType
            Set the type of job step.
        .Parameter IsBundle
            Set to $true, if step contains a bundle.
        .Parameter BundleName
            Valid bundle name.
        .Outputs
            Jobstep object (see bConnect documentation for more details)
    #>

    [OutputType("System.Management.Automations.PSObject")]
    Param(
        [Parameter(Mandatory=$true)][string]$ApplicationGuid,
        [Parameter(Mandatory=$true)][int]$Sequence = 1,
        [Parameter(Mandatory=$true)][ValidateSet("Deploy","SoftwareDeployUninstall",ignoreCase=$true)][string]$JobStepType,
        [Parameter(Mandatory=$false)][boolean]$IsBundle = $false,
        [Parameter(Mandatory=$false)][string]$BundleName
    )
    if ($IsBundle -eq $false) {
        $_AppTemp = Get-bConnectApplication -ApplicationGuid $ApplicationGuid
        $_new_application_props = [PSCustomObject]@{Id = $ApplicationGuid; Name = $_AppTemp.Vendor + " " + $_AppTemp.Name + " " + $_AppTemp.Version;}
    }else {
        $_new_application_props = [PSCustomObject]@{Id = $ApplicationGuid; Name = $BundleName; Isbundle = $True}

    }
	$_new_application_arr = @($_new_application_props)
    $_new_jobstep = [PSCustomObject]@{Applications = $_new_application_arr; Sequence = $Sequence; Type = $JobStepType;}
    return $_new_jobstep
}
