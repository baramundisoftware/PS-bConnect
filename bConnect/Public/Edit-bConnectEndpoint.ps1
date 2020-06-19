Function Edit-bConnectEndpoint() {
    <#
        .Synopsis
            Updates a existing endpoint.
        .Parameter Endpoint
            Valid modified endpoint
        .Outputs
            Endpoint (see bConnect documentation for more details).
    #>


    Param (
        [Parameter(Mandatory=$true)][PSCustomObject]$Endpoint
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If(Test-Guid $Endpoint.Id) {
            # We can not send the whole object because of not editable fields.
            # So we need to create a new one with editable fields only...
			# And as this might be too easy, we face another problem: we are only allowed to send the changed fields :(
			# Dirty workaround: reload the object and compare new vs. old
			$_old_endpoint = Get-bConnectEndpoint -EndpointGuid $Endpoint.Id
			$_old_endpoint = ConvertTo-Hashtable $_old_endpoint

			# common properties
            $_new_endpoint = @{ Id = $Endpoint.Id }
			$_propertyList = @(
                "DisplayName",
                "GuidOrgUnit",
        		"Comments"
            )
            $Endpoint = ConvertTo-Hashtable $Endpoint

            # Windows
			If($Endpoint.Type -eq [bConnectEndpointType]::WindowsEndpoint) {
                $_propertyList += @(
                    "HostName",
                    "Options",
                    "PrimaryMAC",
                    "Domain",
                    "GuidBootEnvironment",
                    "GuidHardwareProfile",
                    "PublicKey",
                    "Mode",
                    "ExtendedInternetMode",
		            "PrimaryUser",
		            "PrimaryIP",
		            "CustomStateText",
		            "CustomStateType"
                )
			}

            # BmsNet = Android, iOS, WP (deprecated!), OSX
			If(($Endpoint.Type -eq [bConnectEndpointType]::AndroidEndpoint) -or
				($Endpoint.Type -eq [bConnectEndpointType]::iOSEndpoint) -or
				($Endpoint.Type -eq [bConnectEndpointType]::WindowsPhoneEndpoint) -or
				($Endpoint.Type -eq [bConnectEndpointType]::MacEndpoint)) {
                $_propertyList += @(
                    "PrimaryUser",
                    "Owner",
                    "ComplianceCheckCategory"
                )
			}

			# OSX
			If($Endpoint.Type -eq [bConnectEndpointType]::MacEndpoint) {
                $_propertyList += @(
                    "HostName"
                )
            }

			Foreach($_property in $_propertyList) {
                If($Endpoint[$_property] -ine $_old_endpoint[$_property]) {
                    $_new_endpoint += @{ $_property = $Endpoint[$_property] }
                }
			}

            return Invoke-bConnectPatch -Controller "Endpoints" -Version $_connectVersion -objectGuid $Endpoint.Id -Data $_new_endpoint
        } else {
            return $false
        }
    } else {
        return $false
    }
}
