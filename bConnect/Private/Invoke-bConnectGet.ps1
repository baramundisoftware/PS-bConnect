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
        If($Data.Count -gt 0) {
            $_rest = Invoke-RestMethod -Uri $_uri -Body $Data -Credential $script:_connectCredentials -Method Get -ContentType "application/json" -TimeoutSec $script:_ConnectionTimeout
        } else {
            $_rest = Invoke-RestMethod -Uri $_uri -Credential $script:_connectCredentials -Method Get -ContentType "application/json" -TimeoutSec $script:_ConnectionTimeout
        }

        If($_rest) {
            return $_rest
        } else {
            return $true
        }
    }

    catch {
        Try {
            $_response = ConvertFrom-Json $_
        }

        Catch {
            $_response = $false
        }

        If($_response) {
            Write-Error $_response.Message
        } else {
            Write-Error $_
        }

        return $false
    }
}
