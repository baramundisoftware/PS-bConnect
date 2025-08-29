Function Invoke-bConnectPut() {
    <#
        .Synopsis
            INTERNAL - HTTP-PUT against bConnect
        .Parameter Data
            Hashtable with parameters
        .Parameter Version
            bConnect version to use
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)][string]$Controller,
        [Parameter(Mandatory=$true)][PSCustomObject]$Data,
        [string]$Version
    )

    If(!$script:_connectInitialized) {
        Write-Error "bConnect module is not initialized. Use 'Initialize-bConnect' first!"
        return $false
    }

    If([string]::IsNullOrEmpty($Version)) {
        $Version = $script:_bConnectFallbackVersion
    }

    If($verbose){
        $ProgressPreference = "Continue"
    } else {
        $ProgressPreference = "SilentlyContinue"
    }

    try {
        If($Data.Count -gt 0) {
            $_body = ConvertTo-Json $Data

            $invokeParams = @{
                Uri = "$($script:_connectUri)/$($Version)/$($Controller)"
                Body = $_body
                Credential = $script:_connectCredentials
                Method = 'Put'
                ContentType = 'application/json; charset=utf-8'
            }

            if ($script:_skipCertificateCheck) {
                $invokeParams.SkipCertificateCheck = $true
            }

            $_rest = Invoke-RestMethod @invokeParams
            If($_rest) {
                return $_rest
            } else {
                return $true
            }
        } else {
            return $false
        }
    }

    catch {
        $_errMsg = ""

        Try {
            if ($PSVersionTable.PSEdition -eq 'Core') {
                # In PowerShell 7+, the actual response is in the stream of the exception's response object
                $stream = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($stream)
                $responseBody = $reader.ReadToEnd()
                $reader.Close()
                $stream.Close()
                $_response = ConvertFrom-Json $responseBody
            } else {
                # In Windows PowerShell 5.1, the error record itself can sometimes be converted
                $_response = ConvertFrom-Json $_
            }
        }
        Catch {
            $_response = $false
        }

        If($_response) {
            $_errMsg = $_response.Message
        } else {
            $_errMsg =  $_.Exception.Message
        }

        If($_body) {
            $_errMsg = "$($_errMsg) `nBody: $($_body)"
        }

        Write-Error $_errMsg

        return $false
    }
}
