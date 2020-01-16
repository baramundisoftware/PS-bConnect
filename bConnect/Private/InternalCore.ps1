# internal - GET data from bConnect
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

# internal - POST data to bConnect
Function Invoke-bConnectPost() {
    <#
        .Synopsis
            INTERNAL - HTTP-POST against bConnect
        .Parameter Data
            Hashtable with parameters
        .Parameter Version
            bConnect version to use
    #>

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

            $_rest = Invoke-RestMethod -Uri "$($script:_connectUri)/$($Version)/$($Controller)" -Body $_body -Credential $script:_connectCredentials -Method Post -ContentType "application/json"
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
            $_response = ConvertFrom-Json $_
        }

        Catch {
            $_response = $false
        }

        If($_response) {
            $_errMsg = $_response.Message
        } else {
            $_errMsg =  $_
        }

        If($_body) {
            $_errMsg = "$($_errMsg) `nHashtable: $($_body)"
        }

        Write-Error $_errMsg

        return $false
    }
}

# internal - PUT data to bConnect
Function Invoke-bConnectPut() {
    <#
        .Synopsis
            INTERNAL - HTTP-PUT against bConnect
        .Parameter Data
            Hashtable with parameters
        .Parameter Version
            bConnect version to use
    #>

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

            $_rest = Invoke-RestMethod -Uri "$($script:_connectUri)/$($Version)/$($Controller)" -Body $_body -Credential $script:_connectCredentials -Method Put -ContentType "application/json"
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
            $_response = ConvertFrom-Json $_
        }

        Catch {
            $_response = $false
        }

        If($_response) {
            $_errMsg = $_response.Message
        } else {
            $_errMsg =  $_
        }

        If($_body) {
            $_errMsg = "$($_errMsg) `nHashtable: $($_body)"
        }

        Write-Error $_errMsg

        return $false
    }
}

# internal - DELETE data from bConnect
Function Invoke-bConnectDelete() {
    <#
        .Synopsis
            INTERNAL - HTTP-DELETE against bConnect
        .Parameter Data
            Hashtable with parameters
        .Parameter Version
            bConnect version to use
    #>

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
        $_params = @()
        Foreach($_key in $Data.Keys) {
            $_params += "$($_key)=$($Data.Get_Item($_key))"
        }

        $_rest = Invoke-RestMethod -Uri "$($script:_connectUri)/$($Version)/$($Controller)?$($_params)" -Credential $script:_connectCredentials -Method Delete -ContentType "application/json"
        If($_rest) {
            return $_rest
        } else {
            return $true
        }
    }

    catch {
        $_errMsg = ""

        Try {
            $_response = ConvertFrom-Json $_
        }

        Catch {
            $_response = $false
        }

        If($_response) {
            $_errMsg = $_response.Message
        } else {
            $_errMsg =  $_
        }

        If($_body) {
            $_errMsg = "$($_errMsg) `nHashtable: $($Data)"
        }

        Write-Error $_errMsg

        return $false
    }
}

# internal - PATCH data to bConnect
Function Invoke-bConnectPatch() {
    <#
        .Synopsis
            INTERNAL - HTTP-PATCH against bConnect
        .Parameter Data
            Hashtable with parameters
        .Parameter Version
            bConnect version to use
    #>

    Param(
        [Parameter(Mandatory=$true)][string]$Controller,
        [Parameter(Mandatory=$true)][PSCustomObject]$Data,
        [string]$objectGuid,
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

            If(![string]::IsNullOrEmpty($objectGuid)) {
                $_rest = Invoke-RestMethod -Uri "$($script:_connectUri)/$($Version)/$($Controller)?id=$($objectGuid)" -Body $_body -Credential $script:_connectCredentials -Method Patch -ContentType "application/json"
            } else {
                $_rest = Invoke-RestMethod -Uri "$($script:_connectUri)/$($Version)/$($Controller)" -Body $_body -Credential $script:_connectCredentials -Method Patch -ContentType "application/json"
            }

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
            $_response = ConvertFrom-Json $_
        }

        Catch {
            $_response = $false
        }

        If($_response) {
            $_errMsg = $_response.Message
        } else {
            $_errMsg =  $_
        }

        If($_body) {
            $_errMsg = "$($_errMsg) `nHashtable: $($_body)"
        }

        Write-Error $_errMsg

        return $false
    }
}

# check version
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
