Function Get-bConnectVersion() {
    <#
        .Synopis
            Checks for supported bConnect version and returns the version (e.g. "v1.0").
    #>

    [CmdletBinding()]
    Param (
        [switch]$bMSVersion
    )

    $_info = Get-bConnectInfo

    If($_info) {
        $_bcVersion = "v$($_info.bConnectVersion)"
        $_bmsVersion = $_info.bMSVersion

        switch -Wildcard ($_bmsVersion) {
            "19.*" {
                Write-Verbose "DEPRECATED! bConnect 2019 R1 or newer"
            }

	    "20.*" {
                Write-Verbose "bConnect 2020 R1 or newer"
            }

            "21.*" {
                Write-Verbose "bConnect 2021 R1 or newer"
            }

            "22.*" {
                Write-Verbose "bConnect 2022 R1 or newer"
            }

	    "23.*" {
		Write-Verbose "bConnect 2023 R1 or newer"
            }

            default {
                Write-Warning "UNSUPPORTED bMS Version $($_bmsVersion)! Unknown bConnect Version -> Fallback to $($script:_bConnectFallbackVersion)"
                $_bcVersion = $script:_bConnectFallbackVersion
            }
        }

        If($bMSVersion) {
            return $_bmsVersion
        } else {
            return $_bcVersion
        }
    }
}
