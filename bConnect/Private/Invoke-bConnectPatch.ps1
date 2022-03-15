Function Invoke-bConnectPatch() {
    <#
        .Synopsis
            INTERNAL - HTTP-PATCH against bConnect
        .Parameter Data
            Hashtable with parameters
        .Parameter Version
            bConnect version to use
        .Parameter IgnoreAssignments
            If true, bConnect will update the specified Job without error, even if it is assigned already.
    #>

    Param(
        [Parameter(Mandatory=$true)][string]$Controller,
        [Parameter(Mandatory=$true)][PSCustomObject]$Data,
        [string]$objectGuid,
        [string]$Version,
        [boolean]$IgnoreAssignments
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
            $_body = ConvertTo-Json $Data -Depth 5
            $_uri = "$($script:_connectUri)/$($Version)/$($Controller)?"

            If(![string]::IsNullOrEmpty($objectGuid)) {
                $_uri += "id=$($objectGuid)"
            }
            If($IgnoreAssignments){
                $_uri += "&ignoreAssignments=true"
            }

            $_rest = Invoke-RestMethod -Uri $_uri -Body $_body -Credential $script:_connectCredentials -Method Patch -ContentType "application/json; charset=utf-8"


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
