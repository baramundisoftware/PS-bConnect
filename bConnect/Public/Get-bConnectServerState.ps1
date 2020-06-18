Function Get-bConnectServerState() {
    <#
        .Synopsis
            Get current baramundi server state.        
        .Outputs
            ServerState object representing the current state of the baramundi server and its sub service
    #>

    $_connectVersion = Get-bConnectVersion
    If($_connectVersion -ge "1.0") {
        return Invoke-bConnectGet -Controller "ServerState" -Version $_connectVersion     
    } else {
        return $false
    }
}
