Function Get-bConnectEndpoint() {
    <#
        .Synopsis
            Get specified endpoint or all endpoints in given OrgUnit
        .Parameter EndpointGuid
            Valid GUID of a endpoint
        .Parameter OrgUnitGuid
            Valid GUID of an Orgunit
        .Parameter Username
            Valid Username
        .Parameter PublicKey
            If set, the result contains the associated public keys.
        .Parameter InstalledSoftware
            If set, the result contains the installed software.
        .Parameter SnmpData
            If set, the result contains the associated snmp data.
        .Outputs
            Array of Endpoint (see bConnect documentation for more details)
    #>

    Param (
        [string]$EndpointGuid,
        [string]$OrgUnitGuid,
        [string]$DynamicGroupGuid,
        [string]$StaticGroupGuid,
        [string]$UniversalDynamicGroupGuid,
        [string]$Username,
        [switch]$PublicKey,
        [switch]$InstalledSoftware,
        [switch]$SnmpData
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        $_body = @{}
        If($EndpointGuid) {
            $_body = @{
                Id = $EndpointGuid
            }
        }

        If($OrgUnitGuid) {
            $_body = @{
                OrgUnit = $OrgUnitGuid
            }
        }

        If($DynamicGroupGuid) {
            $_body = @{
                DynamicGroup = $DynamicGroupGuid
            }
        }

        If($StaticGroupGuid) {
            $_body = @{
                StaticGroup = $StaticGroupGuid
            }
        }

        If($UniversalDynamicGroupGuid) {
            $_body = @{
                UniversalDynamicGroup = $UniversalDynamicGroupGuid
            }
        }

        If($Username) {
            $_body = @{
                User = $Username
            }
        }

        If($PublicKey) {
            $_body += @{
                PubKey = $true
            }
        }

        If($InstalledSoftware) {
            $_body += @{
                InstalledSoftware = $true
            }
        }

        If($SnmpData) {
            $_body += @{
                SnmpData = $true
            }
        }

        return Invoke-bConnectGet -Controller "Endpoints" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
