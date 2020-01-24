Function Get-bConnectBootEnv() {
    <#
        .Synopsis
            Get specified BootEnvironment or a list of all boot environments
        .Parameter BootEnvironmentGuid
            Valid GUID of a boot environment
        .Outputs
            Array of BootEnvironment (see bConnect documentation for more details)
    #>

    Param (
        [string]$BootEnvironmentGuid
    )

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        If($BootEnvironmentGuid) {
            $_body = @{
                Id = $BootEnvironmentGuid
            }
        }

        return Invoke-bConnectGet -Controller "BootEnvironment" -Version $_connectVersion -Data $_body
    } else {
        return $false
    }
}
