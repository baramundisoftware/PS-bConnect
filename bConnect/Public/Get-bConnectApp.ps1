Function Get-bConnectApp() {
    <#
        .Synopsis
            Get specified app, all apps in given OrgUnit or all apps on an specific endpoint.
        .Parameter AppGuid
            Valid GUID of a app.
        .Parameter OrgUnitGuid
            Valid GUID of a Orgunit.
        .Parameter EndpointGuid
            Valid GUID of an endpoint.
        .Outputs
            Array of App (see bConnect documentation for more details).
    #>
    
    [CmdletBinding()]
    Param (
        [string]$AppGuid,
        [string]$OrgUnitGuid,
        [string]$EndpointGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($EndpointGuid) {
            $_body = @{
                EndpointId = $EndpointGuid
            }
        }

        If($OrgUnitGuid) {
            $_body = @{
                OrgUnit = $OrgUnitGuid
            }
        }

        If($AppGuid) {
            $_body = @{
                Id = $AppGuid
            }
        }

        return Invoke-bConnectGet -Controller "Apps" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
