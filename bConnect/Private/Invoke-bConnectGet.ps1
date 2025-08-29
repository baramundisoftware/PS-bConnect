Function Invoke-bConnectGet() {
    <#
        .Synopsis
            INTERNAL - HTTP-GET against bConnect
        .Parameter Data
            Hashtable with parameters
        .Parameter Version
            bConnect version to use
        .Parameter NoVersion
            Dont use a version in the request. Needed for "info" and "version"
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)][string]$Controller,
        [PSCustomObject]$Data,
        [string]$Version,
        [switch]$NoVersion
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

    If($NoVersion) {
        $_uri = "$($script:_connectUri)/$($Controller)"
    } else {
        $_uri = "$($script:_connectUri)/$($Version)/$($Controller)"
    }

    try {
        $invokeParams = @{
            Uri = $_uri
            Credential = $script:_connectCredentials
            Method = 'Get'
            ContentType = 'application/json; charset=utf-8'
            TimeoutSec = $script:_ConnectionTimeout
        }

        if ($script:_skipCertificateCheck) {
            $invokeParams.SkipCertificateCheck = $true
        }

        If($Data.Count -gt 0) {
            $invokeParams.Body = $Data
        }
        
        $_rest = Invoke-RestMethod @invokeParams
        

        If($_rest) {
            return $_rest
        } else {
            return $true
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

        If($Data) {
            $_errMsg = "$($_errMsg) `nData: $($Data | Out-String)"
        }

        Write-Error $_errMsg

        return $false
    }
}
