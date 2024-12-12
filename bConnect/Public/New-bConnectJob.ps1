Function New-bConnectJob() {
    <#
        .Synopsis
            Create a new job.
        .Parameter Name
            Name of a job
        .Parameter DisplayName
            Display name of a job. Visible in the bMA TrayNotifier and Kiosk.
        .Parameter Type
            Job type: Windows, Mobile, Universal
        .Parameter Steps
            The job steps which the job will execute.
        .Parameter ParentId
            The GUID of the new jobs parent OU.
        .Parameter Id
            The GUID of the new job object, optional.
        .Parameter Category
            The job’s category.
        .Parameter Description
            The job’s description.
        .Parameter Comments
            Admin’s comment.
        .Parameter IconId
            The id of the job’s icon, which is visible in the Kiosk.
        .Parameter JobExecutionTimeout
            The execution timeout of the job.
        .Parameter AbortOnError
            If set to true the job aborts after an erroneous job step.			
        .Parameter RemoveInstanceAfterCompletion
            If set to true the job assignment will be deleted after successful execution.

        .Parameter WindowsProperties
            The windows properties of the job. Must not be null if job is for windows endpoints. Must be null if job is for mobile or mac endpoints.
        .Parameter MobileAndMacProperties
            The mobile and mac properties of the job. Must not be null if job is for mobile or mac endpoints. Must be null if the job is for windows endpoints.
        .Parameter UniversalProperties
            The properties of a universal job. Must be null if the job is for windows or mobile endpoints.
			
        .Outputs
            NewJob (see bConnect documentation for more details).
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'low')]
    [OutputType("System.Management.Automations.PSObject","System.Boolean")]
    Param (
		[Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][string]$DisplayName,
        [Parameter(Mandatory=$true)][ValidateSet("Windows","Mobile","Universal",ignoreCase=$true)][string]$Type,
		[Parameter(Mandatory=$true)][PSCustomObject[]]$Steps,
        [string]$ParentId = "C6567FDB-74B4-40C1-846D-12011A163B4A", #guid of "Job Management" as fallback
		[string]$Id,
        [string]$Category,
        [string]$Description,
        [string]$Comments,
		[string]$IconId,
		[int]$JobExecutionTimeout = 0,
        [bool]$AbortOnError = $true,
        [bool]$RemoveInstanceAfterCompletion = $false,
        [PSCustomObject]$WindowsProperties,
        [PSCustomObject]$MobileAndMacProperties,
        [PSCustomObject]$UniversalProperties
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            # Id = $Id;
			Name = $Name;
            DisplayName = $DisplayName;
            Type = $Type;
			Steps = $Steps;
            ParentId = $ParentId;
			JobExecutionTimeout = $JobExecutionTimeout;
			AbortOnError = $AbortOnError;
			RemoveInstanceAfterCompletion = $RemoveInstanceAfterCompletion
        }

		If(![string]::IsNullOrEmpty($Id)) {
			$_body += @{ Id = $Id }
		}

		If(![string]::IsNullOrEmpty($Category)) {
			$_body += @{ Category = $Category }
		}

		If(![string]::IsNullOrEmpty($Description)) {
			$_body += @{ Description = $Description }
		}

		If(![string]::IsNullOrEmpty($Comments)) {
			$_body += @{ Comments = $Comments }
		}

		If(![string]::IsNullOrEmpty($IconId)) {
			$_body += @{ IconId = $IconId }
		}

<# 		If($JobExecutionTimeout.HasValue()) {
			$_body += @{ JobExecutionTimeout = $JobExecutionTimeout }
		}

		If($AbortOnError.HasValue()) {
			$_body += @{ AbortOnError = $AbortOnError }
		}

		If($RemoveInstanceAfterCompletion.HasValue()) {
			$_body += @{ RemoveInstanceAfterCompletion = $RemoveInstanceAfterCompletion }
		} #>

		If($WindowsProperties) {
			$_body += @{ WindowsProperties = $WindowsProperties }
		}

		If($MobileAndMacProperties) {
			$_body += @{ MobileAndMacProperties = $MobileAndMacProperties }
		}

        If($UniversalProperties) {
            $_body += @{ UniversalProperties = $UniversalProperties }
        }

        if($PSCmdlet.ShouldProcess($_body.Name, "Create new job.")){
            return Invoke-bConnectPost -Controller "Jobs" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
