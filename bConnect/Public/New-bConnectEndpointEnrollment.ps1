Function New-bConnectEndpointEnrollment() {
    <#
        .Synopsis
            Set an endpoint into enrollment mode.
        .Parameter EndpointId
            Valid GUID of an existing Windows endpoint.
        .Parameter EmailRecipient
            Valid Email address to send the enrollment information to.
        .Parameter Sync
            If set, the enrollment controller waits for the mail to be transfered to the SMTP server.
        .Outputs
            EnrollmentData (see bConnect documentation for more details).
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    [OutputType("System.Management.Automations.PSObject","System.Boolean")]
    Param (
        [Parameter(Mandatory=$true)][string]$EndpointId,
        [string]$EmailRecipient,
        [switch]$Sync
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{
            EndpointId = $EndpointId;
        }

		If(![string]::IsNullOrEmpty($EmailRecipient)) {
			$_body += @{ EmailRecipient = $EmailRecipient }
		}

		If($Sync) {
			$_body += @{ Sync = $true }
		}

        if($PSCmdlet.ShouldProcess($_body.EndpointId, "Set endpoint to enrollment mode.")){
            return Invoke-bConnectPost -Controller "EndpointEnrollment" -Version $_connectVersion -Data $_body
        } else {
            return $false
        }
    } else {
        return $false
    }
}
