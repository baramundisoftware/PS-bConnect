Function Get-bConnectVersion() {
    <#
        .Synopis
            Checks for supported bConnect version and returns the version (e.g. "v1.0").
    #>

    Param (
        [switch]$bMSVersion
    )

    $_info = Get-bConnectInfo

    If($_info) {
        $_bcVersion = "v$($_info.bConnectVersion)"
        $_bmsVersion = $_info.bMSVersion

        switch -Wildcard ($_bmsVersion) {
            "14.0.*" {
                Write-Warning "DEPRECATED! bConnect 2014R1"
            }

            "14.2.*" {
                Write-Warning "DEPRECATED! bConnect 2014R2"
            }

            "15.*" {
                Write-Verbose "DEPRECATED! bConnect 2015R1 or newer"
            }

			"16.*" {
				Write-Verbose "DEPRECATED! bConnect 2016R1 or newer"
			}

			"17.*" {
				Write-Verbose "DEPRECATED! bConnect 2017R1 or newer"
			}

			"18.*" {
				Write-Verbose "bConnect 2018R1 or newer"
			}

			"19.*" {
				Write-Verbose "bConnect 2019R1 or newer"
			}

			"20.*" {
				Write-Verbose "bConnect 2020R1 or newer"
			}

            default {
                Write-Warning "NOT SUPPORTED! Unknown bConnect Version -> Fallback to $($script:_bConnectFallbackVersion)"
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
