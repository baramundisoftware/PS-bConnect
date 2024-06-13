﻿Function Get-bConnectServerState() {
    <#
        .Synopsis
            Get baramundi server and sub services state.
        .Outputs
            ServerState object representing the current state of the baramundi server and its sub services
    #>

    [CmdletBinding()]
    Param ()

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "v1.0") {
        return Invoke-bConnectGet -Controller "ServerState" -Version $_connectVersion
    } else {
        return $false
    }
}
