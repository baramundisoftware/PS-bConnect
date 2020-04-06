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

        $_rest = Invoke-RestMethod -Uri "$($script:_connectUri)/$($Version)/$($Controller)?$($_params)" -Credential $script:_connectCredentials -Method Delete -ContentType "application/json; charset=utf-8"
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
