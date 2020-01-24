Function Get-bConnectHardwareProfile() {
    <#
        .Synopsis
            Get specified HardwareProfile or a list of all hardware profiles
        .Parameter HardwareProfileGuid
            Valid GUID of a hardware profile
        .Outputs
            Array of HardwareProfile (see bConnect documentation for more details)
    #>

    Param (
        [string]$HardwareProfileGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($HardwareProfileGuid) {
            $_body = @{
                Id = $HardwareProfileGuid
            }
        }

        return Invoke-bConnectGet -Controller "HardwareProfiles" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
