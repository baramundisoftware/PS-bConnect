Function Get-bConnectApplication() {
    <#
        .Synopsis
            Get specified application, all applications in given OrgUnit or all applications on an specific endpoint.
        .Parameter ApplicationGuid
            Valid GUID of a application.
        .Parameter OrgUnitGuid
            Valid GUID of a Orgunit.
        .Parameter EndpointGuid
            Valid GUID of an endpoint.
        .Outputs
            Array of Application (see bConnect documentation for more details).
    #>

    [CmdletBinding()]
    Param (
        [string]$ApplicationGuid,
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

        If($ApplicationGuid) {
            $_body = @{
                Id = $ApplicationGuid
            }
        }

        return Invoke-bConnectGet -Controller "Applications" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
