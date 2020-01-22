# fetch bConncet info
Function Get-bConnectInfo() {
    <#
        .Synopsis
            Gets info from bConnect.
    #>

    If(!$script:_bConnectInfo) {
        $script:_bConnectInfo = Invoke-bConnectGet -Controller "info" -noVersion
    }

    return $script:_bConnectInfo
}
